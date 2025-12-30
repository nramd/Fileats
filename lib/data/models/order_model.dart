import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String menuItemId;
  final String menuItemName;
  final double price;
  final int quantity;
  final String?  notes;

  OrderItem({
    required this.menuItemId,
    required this.menuItemName,
    required this.price,
    required this.quantity,
    this. notes,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuItemId: map['menuItemId'] ??  '',
      menuItemName: map['menuItemName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ??  1,
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'price': price,
      'quantity': quantity,
      'notes': notes,
    };
  }

  double get totalPrice => price * quantity;
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String tenantId;
  final String tenantName;
  final List<OrderItem> items;
  final double subtotal;
  final double serviceFee;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String?  paymentStatus;
  final int estimatedMinutes;
  final String?  notes;
  final DateTime createdAt;
  final DateTime?  confirmedAt;
  final DateTime?  completedAt;

  OrderModel({
    required this.id,
    required this. buyerId,
    required this. buyerName,
    required this.tenantId,
    required this.tenantName,
    required this.items,
    required this.subtotal,
    required this.serviceFee,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.paymentStatus,
    required this.estimatedMinutes,
    this.notes,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
  });

  factory OrderModel. fromFirestore(DocumentSnapshot doc) {
    final data = doc. data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ??  '',
      tenantId: data['tenantId'] ?? '',
      tenantName: data['tenantName'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ??  0).toDouble(),
      serviceFee: (data['serviceFee'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'qris',
      paymentStatus:  data['paymentStatus'],
      estimatedMinutes: data['estimatedMinutes'] ?? 15,
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      confirmedAt:  (data['confirmedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'buyerId':  buyerId,
      'buyerName': buyerName,
      'tenantId': tenantId,
      'tenantName':  tenantName,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'serviceFee':  serviceFee,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'estimatedMinutes': estimatedMinutes,
      'notes': notes,
      'createdAt': Timestamp. fromDate(createdAt),
      'confirmedAt': confirmedAt != null ? Timestamp.fromDate(confirmedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  OrderModel copyWith({
    String? id,
    String?  buyerId,
    String? buyerName,
    String? tenantId,
    String? tenantName,
    List<OrderItem>? items,
    double? subtotal,
    double?  serviceFee,
    double?  totalAmount,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    int? estimatedMinutes,
    String? notes,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
  }) {
    return OrderModel(
      id: id ??  this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      tenantId: tenantId ?? this.tenantId,
      tenantName: tenantName ?? this.tenantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      serviceFee: serviceFee ?? this.serviceFee,
      totalAmount: totalAmount ??  this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      notes: notes ??  this.notes,
      createdAt: createdAt ?? this. createdAt,
      confirmedAt: confirmedAt ?? this. confirmedAt,
      completedAt: completedAt ?? this. completedAt,
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}