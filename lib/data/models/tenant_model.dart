import 'package:cloud_firestore/cloud_firestore.dart';

class TenantModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String ownerId;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final double rating;
  final int totalReviews;
  final List<String> categories;
  final DateTime createdAt;

  TenantModel({
    required this.id,
    required this.name,
    required this.description,
    required this. imageUrl,
    required this. ownerId,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    required this.rating,
    required this. totalReviews,
    required this.categories,
    required this.createdAt,
  });

  factory TenantModel. fromFirestore(DocumentSnapshot doc) {
    final data = doc. data() as Map<String, dynamic>;
    return TenantModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ??  '',
      ownerId: data['ownerId'] ?? '',
      isOpen: data['isOpen'] ?? false,
      openTime: data['openTime'] ?? '08:00',
      closeTime:  data['closeTime'] ?? '17:00',
      rating: (data['rating'] ??  0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      categories: List<String>.from(data['categories'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description':  description,
      'imageUrl':  imageUrl,
      'ownerId': ownerId,
      'isOpen': isOpen,
      'openTime': openTime,
      'closeTime': closeTime,
      'rating': rating,
      'totalReviews':  totalReviews,
      'categories': categories,
      'createdAt':  Timestamp.fromDate(createdAt),
    };
  }

  TenantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    double? rating,
    int? totalReviews,
    List<String>? categories,
    DateTime? createdAt,
  }) {
    return TenantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ??  this.ownerId,
      isOpen: isOpen ?? this. isOpen,
      openTime:  openTime ?? this.openTime,
      closeTime: closeTime ??  this.closeTime,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      categories: categories ??  this.categories,
      createdAt: createdAt ?? this. createdAt,
    );
  }
}