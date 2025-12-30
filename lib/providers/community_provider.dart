import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/community_post_model.dart';
import '../core/constants/app_constants.dart';

class CommunityProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CommunityPostModel> _posts = [];
  bool _isLoading = false;
  String?  _errorMessage;

  List<CommunityPostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection(AppConstants.communityPostsCollection)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      _posts = snapshot.docs.map((d) => CommunityPostModel. fromFirestore(d)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> createPost({
    required String authorId,
    required String authorName,
    required String authorPhotoUrl,
    required String authorRole,
    String? tenantId,
    String? tenantName,
    required String content,
    String? imageUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final docRef = await _firestore. collection(AppConstants.communityPostsCollection).add({
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'authorRole': authorRole,
        'tenantId': tenantId,
        'tenantName': tenantName,
        'content':  content,
        'imageUrl':  imageUrl,
        'likesCount': 0,
        'commentsCount': 0,
        'likedBy': [],
        'createdAt': Timestamp.now(),
      });

      final newPost = CommunityPostModel(
        id: docRef.id,
        authorId: authorId,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        authorRole: authorRole,
        tenantId:  tenantId,
        tenantName: tenantName,
        content: content,
        imageUrl: imageUrl,
        likesCount: 0,
        commentsCount: 0,
        likedBy: [],
        createdAt: DateTime.now(),
      );

      _posts.insert(0, newPost);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = _posts[index];
      final isLiked = post.likedBy.contains(userId);

      if (isLiked) {
        await _firestore. collection(AppConstants.communityPostsCollection).doc(postId).update({
          'likedBy': FieldValue.arrayRemove([userId]),
          'likesCount': FieldValue.increment(-1),
        });
        _posts[index] = post.copyWith(
          likedBy: List.from(post.likedBy)..remove(userId),
          likesCount: post.likesCount - 1,
        );
      } else {
        await _firestore.collection(AppConstants. communityPostsCollection).doc(postId).update({
          'likedBy': FieldValue. arrayUnion([userId]),
          'likesCount': FieldValue.increment(1),
        });
        _posts[index] = post.copyWith(
          likedBy: List.from(post.likedBy)..add(userId),
          likesCount:  post.likesCount + 1,
        );
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}