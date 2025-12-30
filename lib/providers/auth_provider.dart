import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';
import '../core/constants/app_constants.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus. loading;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _fetchUserData(user.uid);
      } else {
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password:  password,
      );

      if (credential.user != null) {
        final user = UserModel(
          uid: credential. user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(credential.user!.uid)
            .set(user.toFirestore());

        _currentUser = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _getAuthErrorMessage(e. code);
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> updateUserRole(String role) async {
    if (_currentUser == null) return;

    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(_currentUser!. uid)
          .update({
        'role': role,
        'updatedAt':  Timestamp.now(),
      });

      _currentUser = _currentUser!.copyWith(role: role);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar.  Silakan gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password': 
        return 'Password terlalu lemah. Minimal 6 karakter.';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password': 
        return 'Password salah.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}