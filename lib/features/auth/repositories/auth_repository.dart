import 'package:flutter/foundation.dart' show kIsWeb;
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

  // Google Sign-In must only be initialized once per app lifetime.
  static bool _googleSignInInitialized = false;

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

      final userDoc = await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        return UserModel(
          uid: data['uid'] ?? userCredential.user!.uid,
          name: data['name'] ?? 'User',
          email: data['email'] ?? email,
        );
      } else {
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
      UserCredential userCredential;

      if (kIsWeb) {
        // -------------------------------------------------------
        // WEB: google_sign_in's authenticate() is NOT supported
        // on web (it requires renderButton instead). The reliable
        // approach on web is Firebase's own popup sign-in.
        // -------------------------------------------------------

        final googleProvider = GoogleAuthProvider();

        userCredential =
            await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // -------------------------------------------------------
        // MOBILE (Android/iOS): use google_sign_in's authenticate()
        // -------------------------------------------------------

        if (!_googleSignInInitialized) {
          await _googleSignIn.initialize();
          _googleSignInInitialized = true;
        }

        final GoogleSignInAccount googleUser =
            await _googleSignIn.authenticate();

        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        final String? idToken = googleAuth.idToken;

        if (idToken == null) {
          throw Exception(
            'Could not get Google ID token. Check your clientId / SHA-1 configuration.',
          );
        }

        final credential = GoogleAuthProvider.credential(
          idToken: idToken,
        );

        userCredential =
            await _firebaseAuth.signInWithCredential(credential);
      }

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

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        return UserModel(
          uid: data['uid'] ?? firebaseUser.uid,
          name: data['name'] ?? firebaseUser.displayName ?? 'User',
          email: data['email'] ?? firebaseUser.email ?? '',
        );
      }

      // -------------------------------------------------------
      // NEW GOOGLE USER
      // -------------------------------------------------------

      final String name = firebaseUser.displayName ?? 'User';
      final String email = firebaseUser.email ?? '';

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
      final userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

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
      await _firebaseAuth.sendPasswordResetEmail(email: email);
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
      final userDoc =
          await _firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

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
      await currentUser?.updateDisplayName(name);

      await _firebaseFirestore.collection('users').doc(uid).update({
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
      await _firebaseFirestore.collection('users').doc(uid).delete();
      await currentUser?.delete();
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }
}