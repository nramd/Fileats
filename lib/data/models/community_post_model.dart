import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String authorPhotoUrl;
  final String authorRole; // 'buyer' or 'seller'
  final String?  tenantId;
  final String?  tenantName;
  final String content;
  final String?  imageUrl;
  final int likesCount;
  final int commentsCount;
  final List<String> likedBy;
  final DateTime createdAt;

  CommunityPostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorPhotoUrl,
    required this.authorRole,
    this.tenantId,
    this.tenantName,
    required this.content,
    this.imageUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.likedBy,
    required this.createdAt,
  });

  factory CommunityPostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityPostModel(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorPhotoUrl: data['authorPhotoUrl'] ?? '',
      authorRole: data['authorRole'] ?? 'buyer',
      tenantId: data['tenantId'],
      tenantName: data['tenantName'],
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoUrl': authorPhotoUrl,
      'authorRole': authorRole,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'content': content,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': likedBy,
      'createdAt': Timestamp. fromDate(createdAt),
    };
  }

  CommunityPostModel copyWith({
    String? id,
    String? authorId,
    String?  authorName,
    String? authorPhotoUrl,
    String?  authorRole,
    String? tenantId,
    String? tenantName,
    String? content,
    String? imageUrl,
    int? likesCount,
    int? commentsCount,
    List<String>? likedBy,
    DateTime? createdAt,
  }) {
    return CommunityPostModel(
      id: id ?? this. id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPhotoUrl: authorPhotoUrl ??  this.authorPhotoUrl,
      authorRole: authorRole ?? this.authorRole,
      tenantId: tenantId ?? this. tenantId,
      tenantName: tenantName ?? this. tenantName,
      content:  content ?? this.content,
      imageUrl: imageUrl ?? this. imageUrl,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool isLikedBy(String userId) => likedBy.contains(userId);
}