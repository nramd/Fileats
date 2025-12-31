import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';
import '../models/cart_item.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Order> _orders = [];
  bool isLoading = true;

  List<Order> get orders => _orders;

  List<Order> get activeOrders => _orders
      .where((order) =>
          order.status != OrderStatus.selesai &&
          order.status != OrderStatus.dibatalkan)
      .toList();

  List<Order> get historyOrders => _orders
      .where((order) =>
          order.status == OrderStatus.selesai ||
          order.status == OrderStatus.dibatalkan)
      .toList();

  void listenToOrders() {
    _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _orders = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> createOrderFromCart(
      List<CartItem> cartItems, int totalAmount) async {
    if (cartItems.isEmpty) return;

    final Map<String, List<CartItem>> itemsByTenant = {};

    for (var item in cartItems) {
      if (!itemsByTenant.containsKey(item.tenant)) {
        itemsByTenant[item.tenant] = [];
      }
      itemsByTenant[item.tenant]!.add(item);
    }

    final List<Future> uploadTasks = [];

    itemsByTenant.forEach((tenantName, items) {
      int tenantTotal =
          items.fold(0, (sum, item) => sum + (item.price * item.quantity));

      // UPDATE DI SINI: Mapping CartItem ke OrderItem
      final List<OrderItem> orderItems = items.map((ci) {
        return OrderItem(
          name: ci.menuName, // Nama Bersih (tanpa catatan)
          quantity: ci.quantity,
          pricePerItem: ci.price,
          note: ci.notes, // Catatan masuk ke field khusus
        );
      }).toList();

      final newOrder = Order(
        id: '',
        tenant: tenantName,
        items: orderItems,
        totalPrice: tenantTotal,
        status: OrderStatus.menunggu,
        createdAt: DateTime.now(),
      );

      uploadTasks.add(_firestore.collection('orders').add(newOrder.toMap()));
    });

    await Future.wait(uploadTasks);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus.name,
      });
    } catch (e) {
      print("Error updating status: $e");
      rethrow;
    }
  }
}