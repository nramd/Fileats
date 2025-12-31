import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedProvider extends ChangeNotifier {
  // Kita tidak butuh List lokal lagi karena kita akan stream langsung dari Firestore
  
  // FUNGSI TAMBAH POSTINGAN KE FIREBASE
  Future<void> addPost(String community, String content) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final String userName = user?.email?.split('@')[0] ?? "User Anonim";

      // Simpan ke Collection 'community_posts'
      await FirebaseFirestore.instance.collection('community_posts').add({
        'community': community,
        'post': content,
        'userId': user?.uid,
        'userName': userName,
        'location': 'Malang, Indonesia', // Bisa dibuat dinamis nanti
        'createdAt': FieldValue.serverTimestamp(), // Agar bisa diurutkan
        'likes': 0,
        'comments': 0,
      });

      notifyListeners();
    } catch (e) {
      print("Error posting feed: $e");
      throw e;
    }
  }
}