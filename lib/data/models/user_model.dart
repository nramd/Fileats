import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'buyer' or 'seller'
  final String?  photoUrl;
  final String? phoneNumber;
  final String? tenantId; // Only for sellers
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this. email,
    required this.name,
    required this.role,
    this.photoUrl,
    this.phoneNumber,
    this.tenantId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role:  data['role'] ?? 'buyer',
      photoUrl: data['photoUrl'],
      phoneNumber:  data['phoneNumber'],
      tenantId: data['tenantId'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'tenantId': tenantId,
      'createdAt':  Timestamp.fromDate(createdAt),
      'updatedAt':  Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String?  uid,
    String? email,
    String? name,
    String? role,
    String?  photoUrl,
    String? phoneNumber,
    String? tenantId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid:  uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this. name,
      role: role ??  this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      tenantId: tenantId ??  this.tenantId,
      createdAt: createdAt ??  this.createdAt,
      updatedAt: updatedAt ??  this.updatedAt,
    );
  }

  bool get isBuyer => role == 'buyer';
  bool get isSeller => role == 'seller';
}