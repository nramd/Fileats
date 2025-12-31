import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

enum OrderStatus { menunggu, diproses, diantar, selesai, dibatalkan }

class OrderItem {
  final String name;
  final int quantity;
  final int pricePerItem;
  final String note; // TAMBAHAN: Field Note

  OrderItem({
    required this.name, 
    required this.quantity, 
    required this.pricePerItem,
    this.note = '', // Default kosong
  });

  // Data dari Firebase -> ke App
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      pricePerItem: map['pricePerItem'] ?? 0,
      note: map['note'] ?? '', // Ambil note dari Firebase
    );
  }

  // Data dari App -> ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'pricePerItem': pricePerItem,
      'note': note, // Simpan note ke Firebase
    };
  }
}

class Order {
  final String id;
  final String tenant;
  final List<OrderItem> items;
  final int totalPrice;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.tenant,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  // Helper untuk ringkasan (opsional)
  String get menuSummary {
    return items.map((e) => "${e.name} x${e.quantity}").join(", ");
  }

  // --- LOGIKA FIREBASE ---

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      tenant: data['tenant'] ?? '',
      totalPrice: data['totalPrice'] ?? 0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.menunggu,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tenant': tenant,
      'totalPrice': totalPrice,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}