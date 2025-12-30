import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  final String id;
  final String tenantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final int preparationTime; // in minutes
  final DateTime createdAt;

  MenuItemModel({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.preparationTime,
    required this.createdAt,
  });

  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItemModel(
      id: doc.id,
      tenantId: data['tenantId'] ??  '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ??  '',
      category: data['category'] ?? '',
      isAvailable: data['isAvailable'] ??  true,
      preparationTime:  data['preparationTime'] ?? 10,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'name': name,
      'description': description,
      'price':  price,
      'imageUrl':  imageUrl,
      'category':  category,
      'isAvailable': isAvailable,
      'preparationTime': preparationTime,
      'createdAt':  Timestamp.fromDate(createdAt),
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? tenantId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool?  isAvailable,
    int?  preparationTime,
    DateTime?  createdAt,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ??  this.isAvailable,
      preparationTime: preparationTime ??  this.preparationTime,
      createdAt: createdAt ??  this.createdAt,
    );
  }
}