import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as app_user;

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with email and password
  Future<app_user.User> signInWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _convertToAppUser(userCredential.user!);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Sign in with Google
  Future<app_user.User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return _convertToAppUser(userCredential.user!);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Register with email and password
  Future<app_user.User> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // Store additional user data in Firestore
      await _storeUserData(userCredential.user!.uid, {
        'name': name,
        'phone': phone,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return _convertToAppUser(userCredential.user!);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Get current user
  Future<app_user.User?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final userData = await _getUserData(firebaseUser.uid);
      return _convertToAppUser(firebaseUser, additionalData: userData);
    } catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  // Store user data in Firestore
  Future<void> _storeUserData(String uid, Map<String, dynamic> data) async {
    await firebase_auth.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final doc = await firebase_auth.FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data() ?? {};
  }

  // Convert Firebase User to App User
  app_user.User _convertToAppUser(
    firebase_auth.User firebaseUser, {
    Map<String, dynamic>? additionalData,
  }) {
    return app_user.User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      name: firebaseUser.displayName ?? additionalData?['name'] ?? '',
      phone: additionalData?['phone'] ?? '',
      profilePicture: firebaseUser.photoURL,
      createdAt: DateTime.parse(additionalData?['createdAt'] ?? DateTime.now().toIso8601String()),
      favoriteCarIds: List<String>.from(additionalData?['favoriteCarIds'] ?? []),
      bookingHistory: List<String>.from(additionalData?['bookingHistory'] ?? []),
    );
  }

  // Handle Firebase Auth Errors
  Exception _handleFirebaseAuthError(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return Exception('No user found with this email');
        case 'wrong-password':
          return Exception('Wrong password');
        case 'email-already-in-use':
          return Exception('Email is already registered');
        case 'invalid-email':
          return Exception('Invalid email address');
        case 'weak-password':
          return Exception('Password is too weak');
        default:
          return Exception(error.message ?? 'Authentication failed');
      }
    }
    return Exception('Authentication failed');
  }
}