import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app/features/auth/model/user_model.dart';



class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ==============================
  // SIGN UP
  // ==============================

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create Firebase account
      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        return null;
      }

      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        name: name,
        email: email,
      );

      // Save user information in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'Signup failed',
      );
    }
  }

  // ==============================
  // LOGIN
  // ==============================

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;

      if (user == null) {
        return null;
      }

      // Get user data from Firestore
      final document = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (document.exists && document.data() != null) {
        return UserModel.fromMap(
          document.data()!,
        );
      }

      // If Firestore data doesn't exist
      return UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? email,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'Login failed',
      );
    }
  }

  // ==============================
  // FORGOT PASSWORD
  // ==============================

  Future<void> resetPassword(
    String email,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'Password reset failed',
      );
    }
  }

  // ==============================
  // LOGOUT
  // ==============================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ==============================
  // CURRENT USER
  // ==============================

  User? get currentUser {
    return _auth.currentUser;
  }

  // ==============================
  // CHECK LOGIN
  // ==============================

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }
}