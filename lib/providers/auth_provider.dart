import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cek apakah user sedang login (Firebase User)
  User? get currentUser => _auth.currentUser;

  // --- LOGIC 1: PEMBELI (Pakai Firebase) ---

  Future<void> loginBuyer(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login Gagal";
    }
  }

  Future<void> signUpBuyer(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Disini akun terbentuk di Firebase Authentication
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sign Up Gagal";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- LOGIC 2: PENJUAL (Hardcoded / Manual) ---

  // Kita buat "Daftar Penjual VIP" disini
  final Map<String, String> _hardcodedSellers = {
    'bangdor@fileats.com': 'Warung Bangdor',
    'elly@fileats.com': 'Lalapan Mbak Elly',
    'indah@fileats.com': 'Warung Bu Indah',
  };

  final String _sellerGlobalPassword = "admin"; 

  // Fungsi ini mengembalikan NAMA TOKO jika sukses, atau null jika gagal
  String? loginSellerManual(String email, String password) {
    // 1. Cek Password dulu
    if (password != _sellerGlobalPassword) {
      return null; // Password salah
    }

    // 2. Cek apakah email ada di daftar VIP
    if (_hardcodedSellers.containsKey(email)) {
      return _hardcodedSellers[email]; // Kembalikan Nama Toko (misal: Warung Bangdor)
    }

    return null; // Email tidak terdaftar sebagai penjual
  }
}