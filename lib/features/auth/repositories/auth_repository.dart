import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/features/auth/model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================================================
  // SIGN UP
  // =========================================================

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('==============================');
      print('SIGN UP STARTED');
      print('Email: ${email.trim()}');
      print('==============================');

      final String cleanName = name.trim();
      final String cleanEmail = email.trim();

      // Firebase Authentication account create
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception('Firebase user could not be created.');
      }

      print('Firebase signup successful.');
      print('UID: ${user.uid}');

      // Save display name in Firebase Authentication
      await user.updateDisplayName(cleanName);

      // Create model
      final UserModel userModel = UserModel(
        uid: user.uid,
        name: cleanName,
        email: cleanEmail,
      );

      // Save user in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      print('Firestore user created successfully.');
      print('SIGN UP COMPLETED');
      print('==============================');

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('==============================');
      print('FIREBASE AUTH ERROR - SIGNUP');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        _authErrorMessage(e),
      );
    } on FirebaseException catch (e) {
      print('==============================');
      print('FIRESTORE ERROR - SIGNUP');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firestore error: ${e.message ?? e.code}',
      );
    } catch (e) {
      print('SIGNUP GENERAL ERROR: $e');

      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final String cleanEmail = email.trim();

      print('==============================');
      print('LOGIN STARTED');
      print('Email: $cleanEmail');
      print('Password length: ${password.length}');
      print('==============================');

      // -------------------------------------------------------
      // 1. Firebase Authentication
      // -------------------------------------------------------

      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception(
          'Login failed. Firebase user was not returned.',
        );
      }

      print('Firebase login successful.');
      print('UID: ${user.uid}');

      // -------------------------------------------------------
      // 2. Firestore user document
      // -------------------------------------------------------

      final DocumentSnapshot<Map<String, dynamic>> document =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .get();

      // -------------------------------------------------------
      // 3. Existing Firestore user
      // -------------------------------------------------------

      if (document.exists && document.data() != null) {
        print('Firestore user found successfully.');

        final Map<String, dynamic> data =
            Map<String, dynamic>.from(
          document.data()!,
        );

        // IMPORTANT:
        // Agar Firestore mein koi field missing/null hai,
        // Firebase Auth se safe fallback le lo.

        data['uid'] = data['uid'] ?? user.uid;

        data['email'] =
            data['email'] ??
            user.email ??
            cleanEmail;

        data['name'] =
            data['name'] ??
            user.displayName ??
            '';

        print('Firestore data prepared successfully.');

        // Ab null assertion wali problem nahi hogi
        final UserModel userModel =
            UserModel.fromMap(data);

        print('UserModel created successfully.');
        print('LOGIN COMPLETED');
        print('==============================');

        return userModel;
      }

      // -------------------------------------------------------
      // 4. Firestore document does not exist
      // -------------------------------------------------------

      print(
        'Firestore user document not found.',
      );

      final String userName =
          user.displayName ?? '';

      final String userEmail =
          user.email ?? cleanEmail;

      final UserModel userModel = UserModel(
        uid: user.uid,
        name: userName,
        email: userEmail,
      );

      // Automatically create Firestore document
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      print(
        'Firestore user document created automatically.',
      );

      print('LOGIN COMPLETED');
      print('==============================');

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('==============================');
      print('FIREBASE AUTH ERROR - LOGIN');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        _authErrorMessage(e),
      );
    } on FirebaseException catch (e) {
      print('==============================');
      print('FIRESTORE ERROR - LOGIN');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firestore error: ${e.message ?? e.code}',
      );
    } catch (e) {
      print('LOGIN GENERAL ERROR: $e');

      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      print('Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      throw Exception(
        _authErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    await _auth.signOut();

    print('User logged out successfully.');
  }

// =========================================================
// DELETE ACCOUNT
// =========================================================

Future<void> deleteAccount() async {
  try {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently signed in.',
      );
    }

    // Delete Firestore user document
    await _firestore
        .collection('users')
        .doc(user.uid)
        .delete();

    print('Firestore user document deleted.');

    // Delete Firebase Authentication account
    await user.delete();

    print('Firebase Authentication account deleted.');
  } on FirebaseAuthException catch (e) {
    print('DELETE ACCOUNT AUTH ERROR: ${e.code}');

    throw Exception(
      _authErrorMessage(e),
    );
  } on FirebaseException catch (e) {
    print('DELETE ACCOUNT FIRESTORE ERROR: ${e.code}');

    throw Exception(
      'Firestore error: ${e.message ?? e.code}',
    );
  } catch (e) {
    print('DELETE ACCOUNT ERROR: $e');

    throw Exception(
      e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
    );
  }
}

// =========================================================
// UPDATE PROFILE
// =========================================================

Future<void> updateProfile({
  required String name,
}) async {
  try {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently signed in.',
      );
    }

    final String cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw Exception(
        'Name cannot be empty.',
      );
    }

    // Update Firebase Authentication
    await user.updateDisplayName(cleanName);

    // Update Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'name': cleanName,
    });

    print('Profile updated successfully.');
  } on FirebaseAuthException catch (e) {
    throw Exception(
      _authErrorMessage(e),
    );
  } on FirebaseException catch (e) {
    throw Exception(
      'Firestore error: ${e.message ?? e.code}',
    );
  } catch (e) {
    throw Exception(
      e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
    );
  }
}
// =========================================================
// CHANGE PASSWORD
// =========================================================

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception(
        'No user is currently signed in.',
      );
    }

    final String email = user.email ?? '';

    if (email.isEmpty) {
      throw Exception(
        'User email could not be found.',
      );
    }

    // -------------------------------------------------------
    // 1. Re-authenticate user with current password
    // -------------------------------------------------------

    final AuthCredential credential =
        EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(
      credential,
    );

    // -------------------------------------------------------
    // 2. Update password
    // -------------------------------------------------------

    await user.updatePassword(newPassword);

    print('Password changed successfully.');
  } on FirebaseAuthException catch (e) {
    print(
      'CHANGE PASSWORD AUTH ERROR: ${e.code}',
    );

    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        throw Exception(
          'Current password is incorrect.',
        );

      case 'weak-password':
        throw Exception(
          'New password is too weak.',
        );

      case 'requires-recent-login':
        throw Exception(
          'Please login again before changing your password.',
        );

      case 'network-request-failed':
        throw Exception(
          'Please check your internet connection.',
        );

      default:
        throw Exception(
          _authErrorMessage(e),
        );
    }
  } catch (e) {
    throw Exception(
      e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
    );
  }
}
// =========================================================
  // CURRENT USER
  // =========================================================
  User? get currentUser {
    return _auth.currentUser;
  }

  // =========================================================
  // IS LOGGED IN
  // =========================================================

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  // =========================================================
  // FIREBASE AUTH ERROR MESSAGES
  // =========================================================

  String _authErrorMessage(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-credential':
        return 'Email or password is incorrect.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}