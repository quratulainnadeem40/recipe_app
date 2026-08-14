// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:recipe_app/features/auth/model/user_model.dart';

// class AuthRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore =
//       FirebaseFirestore.instance;

//   // ==============================
//   // SIGN UP
//   // ==============================

//   Future<UserModel?> signUp({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       // 1. Create Firebase Authentication account
//       final UserCredential credential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );

//       final User? user = credential.user;

//       if (user == null) {
//         throw Exception('User account could not be created.');
//       }

//       // 2. Set Firebase display name
//       await user.updateDisplayName(name.trim());

//       // 3. Create UserModel
//       final UserModel userModel = UserModel(
//         uid: user.uid,
//         name: name.trim(),
//         email: email.trim(),
//       );

//       // 4. Save user data in Firestore
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .set(userModel.toMap());

//       // 5. Return user
//       return userModel;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(
//         e.message ?? 'Firebase signup failed.',
//       );
//     } on FirebaseException catch (e) {
//       throw Exception(
//         e.message ?? 'Firestore error occurred.',
//       );
//     } catch (e) {
//       throw Exception(
//         'Signup failed: $e',
//       );
//     }
//   }

//   // ==============================
//   // LOGIN
//   // ==============================

//   Future<UserModel?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final UserCredential credential =
//           await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );

//       final User? user = credential.user;

//       if (user == null) {
//         return null;
//       }

//       final DocumentSnapshot<Map<String, dynamic>> document =
//           await _firestore
//               .collection('users')
//               .doc(user.uid)
//               .get();

//       if (document.exists && document.data() != null) {
//         return UserModel.fromMap(
//           document.data()!,
//         );
//       }

//       // If Firestore document doesn't exist
//       return UserModel(
//         uid: user.uid,
//         name: user.displayName ?? '',
//         email: user.email ?? email.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       throw Exception(
//         e.message ?? 'Login failed.',
//       );
//     } on FirebaseException catch (e) {
//       throw Exception(
//         e.message ?? 'Firestore error occurred.',
//       );
//     } catch (e) {
//       throw Exception(
//         'Login failed: $e',
//       );
//     }
//   }

//   // ==============================
//   // FORGOT PASSWORD
//   // ==============================

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(
//         email: email.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       throw Exception(
//         e.message ?? 'Password reset failed.',
//       );
//     }
//   }

//   // ==============================
//   // LOGOUT
//   // ==============================

//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   // ==============================
//   // CURRENT USER
//   // ==============================

//   User? get currentUser {
//     return _auth.currentUser;
//   }

//   // ==============================
//   // CHECK LOGIN
//   // ==============================

//   bool get isLoggedIn {
//     return _auth.currentUser != null;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('==============================');
      print('SIGN UP STARTED');
      print('Email: $email');
      print('==============================');

      // Create Firebase Authentication account
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception(
          'Firebase user was not created.',
        );
      }

      print('Firebase UID: ${user.uid}');

      // Save display name in Firebase Auth
      await user.updateDisplayName(
        name.trim(),
      );

      // Create model
      final UserModel userModel = UserModel(
        uid: user.uid,
        name: name.trim(),
        email: email.trim(),
      );

      // Save user information in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
            userModel.toMap(),
          );

      // ========================================================
      // SEND EMAIL VERIFICATION
      // ========================================================

      await user.sendEmailVerification();

      print(
        'Verification email sent to: ${user.email}',
      );

      print('SIGN UP SUCCESS');
      print('==============================');

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('==============================');
      print('FIREBASE AUTH ERROR - SIGNUP');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firebase Auth Error [${e.code}]: '
        '${e.message ?? 'Signup failed.'}',
      );
    } on FirebaseException catch (e) {
      print('==============================');
      print('FIRESTORE ERROR - SIGNUP');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firestore Error [${e.code}]: '
        '${e.message ?? 'Firestore operation failed.'}',
      );
    } catch (e) {
      print('SIGNUP GENERAL ERROR: $e');

      throw Exception(
        'Signup failed: $e',
      );
    }
  }

  // ============================================================
  // SEND VERIFICATION EMAIL AGAIN
  // ============================================================

  Future<void> sendVerificationEmail() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception(
          'No user is currently signed in.',
        );
      }

      await user.sendEmailVerification();

      print(
        'Verification email sent again.',
      );
    } on FirebaseAuthException catch (e) {
      print(
        'VERIFICATION ERROR: ${e.code}',
      );

      throw Exception(
        'Verification Error [${e.code}]: '
        '${e.message ?? 'Could not send verification email.'}',
      );
    }
  }

  // ============================================================
  // CHECK EMAIL VERIFICATION
  // ============================================================

  Future<bool> checkEmailVerified() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        return false;
      }

      // Refresh Firebase user information
      await user.reload();

      final User? updatedUser =
          _auth.currentUser;

      return updatedUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      print(
        'CHECK VERIFICATION ERROR: ${e.code}',
      );

      return false;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      print('==============================');
      print('LOGIN STARTED');
      print('Email: $email');
      print('==============================');

      // Firebase Authentication
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        throw Exception(
          'Firebase user is null.',
        );
      }

      print(
        'Firebase login successful.',
      );

      // ========================================================
      // CHECK EMAIL VERIFICATION
      // ========================================================

      await user.reload();

      final User? currentUser =
          _auth.currentUser;

      if (currentUser == null) {
        throw Exception(
          'Unable to load current user.',
        );
      }

      print(
        'Email verified: ${currentUser.emailVerified}',
      );

      if (!currentUser.emailVerified) {
        // Do NOT allow unverified user to continue
        await _auth.signOut();

        throw Exception(
          'Please verify your email before logging in. '
          'Check your inbox for the verification link.',
        );
      }

      // ========================================================
      // GET USER FROM FIRESTORE
      // ========================================================

      final DocumentSnapshot<
          Map<String, dynamic>> document =
          await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .get();

      print(
        'Firestore document exists: ${document.exists}',
      );

      if (document.exists &&
          document.data() != null) {
        final UserModel userModel =
            UserModel.fromMap(
          document.data()!,
        );

        print(
          'User loaded from Firestore: ${userModel.name}',
        );

        print('LOGIN SUCCESS');

        return userModel;
      }

      // ========================================================
      // FIREBASE AUTH EXISTS BUT FIRESTORE DOES NOT
      // ========================================================

      final UserModel userModel = UserModel(
        uid: currentUser.uid,
        name: currentUser.displayName ?? '',
        email:
            currentUser.email ?? email.trim(),
      );

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(
            userModel.toMap(),
          );

      print(
        'Firestore document created.',
      );

      return userModel;
    } on FirebaseAuthException catch (e) {
      print('==============================');
      print('FIREBASE AUTH ERROR - LOGIN');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firebase Auth Error [${e.code}]: '
        '${e.message ?? 'Login failed.'}',
      );
    } on FirebaseException catch (e) {
      print('==============================');
      print('FIRESTORE ERROR - LOGIN');
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('==============================');

      throw Exception(
        'Firestore Error [${e.code}]: '
        '${e.message ?? 'Firestore operation failed.'}',
      );
    } catch (e) {
      print(
        'LOGIN GENERAL ERROR: $e',
      );

      throw Exception(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );
    }
  }

  // ============================================================
  // RESET PASSWORD
  // ============================================================

  Future<void> resetPassword(
    String email,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'Firebase Auth Error [${e.code}]: '
        '${e.message ?? 'Password reset failed.'}',
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser {
    return _auth.currentUser;
  }

  // ============================================================
  // CHECK LOGIN
  // ============================================================

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }
}