import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends GetxService {
  // =========================================================
  // FIREBASE INSTANCES
  // =========================================================

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  // =========================================================
  // CURRENT USER
  // =========================================================

  User? get currentUser => _firebaseAuth.currentUser;

  // =========================================================
  // LOGIN
  // =========================================================

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore سے user data لو
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        // ✅ fromJson کے بغیر - براہ راست constructor استعمال کریں
        return UserModel(
          uid: data['uid'] ?? userCredential.user!.uid,
          name: data['name'] ?? 'User',
          email: data['email'] ?? email,
        );
      } else {
        // اگر Firestore میں نہیں ہے تو Firebase user سے بناؤ
        return UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user?.displayName ?? 'User',
          email: userCredential.user!.email ?? email,
        );
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }


// =========================================================
// GOOGLE SIGN-IN
// =========================================================

Future<UserModel> signInWithGoogle() async {
  try {
    // -------------------------------------------------------
    // INITIALIZE GOOGLE SIGN-IN
    // -------------------------------------------------------

    await _googleSignIn.initialize();

    // -------------------------------------------------------
    // OPEN GOOGLE ACCOUNT PICKER
    // -------------------------------------------------------

    final GoogleSignInAccount googleUser =
        await _googleSignIn.authenticate();

    // -------------------------------------------------------
    // GET GOOGLE AUTHENTICATION
    // -------------------------------------------------------

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    // -------------------------------------------------------
    // CREATE FIREBASE CREDENTIAL
    // -------------------------------------------------------

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // -------------------------------------------------------
    // SIGN IN TO FIREBASE
    // -------------------------------------------------------

    final UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(
      credential,
    );

    final User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Google sign-in failed.');
    }

    // -------------------------------------------------------
    // CHECK FIRESTORE USER
    // -------------------------------------------------------

    final userDoc = await _firebaseFirestore
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    // -------------------------------------------------------
    // EXISTING USER
    // -------------------------------------------------------

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;

      return UserModel(
        uid: data['uid'] ?? firebaseUser.uid,
        name: data['name'] ??
            firebaseUser.displayName ??
            'User',
        email: data['email'] ??
            firebaseUser.email ??
            '',
      );
    }

    // -------------------------------------------------------
    // NEW GOOGLE USER
    // -------------------------------------------------------

    final String name =
        firebaseUser.displayName ?? 'User';

    final String email =
        firebaseUser.email ?? '';

    await _firebaseFirestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set({
      'uid': firebaseUser.uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // -------------------------------------------------------
    // RETURN USER MODEL
    // -------------------------------------------------------

    return UserModel(
      uid: firebaseUser.uid,
      name: name,
      email: email,
    );
  } catch (e) {
    throw Exception('Google sign-in failed: $e');
  }
}
  // =========================================================
  // SIGNUP
  // =========================================================

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Firebase میں account بنائیں
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Display name update کریں
      await userCredential.user?.updateDisplayName(name);

      // Firestore میں user data save کریں
      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // ✅ UserModel return کریں
      return UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // =========================================================
  // RESET PASSWORD
  // =========================================================

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // =========================================================
  // CHECK IF USER EXISTS
  // =========================================================

  Future<bool> userExists(String uid) async {
    try {
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  // =========================================================
  // GET USER DATA
  // =========================================================

  Future<UserModel> getUserData(String uid) async {
    try {
      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        
        // ✅ fromJson کے بغیر - براہ راست constructor استعمال کریں
        return UserModel(
          uid: data['uid'] ?? uid,
          name: data['name'] ?? 'User',
          email: data['email'] ?? '',
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  // =========================================================
  // UPDATE USER PROFILE
  // =========================================================

  Future<void> updateUserProfile({
    required String uid,
    required String name,
    String? profileImage,
  }) async {
    try {
      // Firebase user update
      await currentUser?.updateDisplayName(name);

      // Firestore update
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .update({
        'name': name,
        if (profileImage != null) 'profileImage': profileImage,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  // =========================================================
  // DELETE ACCOUNT
  // =========================================================

  Future<void> deleteAccount(String uid) async {
    try {
      // Firestore سے delete کریں
      await _firebaseFirestore.collection('users').doc(uid).delete();

      // Firebase سے delete کریں
      await currentUser?.delete();
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }
}