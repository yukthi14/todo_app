import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus { unAuthenticated, authenticated }

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthStatus _status = AuthStatus.unAuthenticated;
  AuthStatus get status => _status;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get currentUserStream => _firebaseAuth.authStateChanges();

  AuthService() {
    _firebaseAuth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a new collection for the new user
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  void _onAuthStateChanged(User? user) {
    _status =
        user == null ? AuthStatus.unAuthenticated : AuthStatus.authenticated;
    notifyListeners();
  }
}
