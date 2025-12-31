import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';
import '../models/cart_item.dart'; // Pastikan import CartItem ada

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Order> _orders = [];
  bool isLoading = true;

  List<Order> get orders => _orders;

  // Filter: Pesanan yang masih aktif
  List<Order> get activeOrders => _orders
      .where((order) =>
          order.status != OrderStatus.selesai &&
          order.status != OrderStatus.dibatalkan)
      .toList();

  // Filter: Pesanan riwayat (selesai/batal)
  List<Order> get historyOrders => _orders
      .where((order) =>
          order.status == OrderStatus.selesai ||
          order.status == OrderStatus.dibatalkan)
      .toList();

  // MENDENGARKAN DATA REAL-TIME DARI FIREBASE
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

  // FUNGSI TEST: Nambah order dummy
  Future<void> addDummyOrder() async {
    final newOrder = Order(
      id: '',
      tenant: 'Warung Bu Indah (Test Firebase)',
      items: [
        OrderItem(name: 'Ayam Bakar', quantity: 1, pricePerItem: 15000),
        OrderItem(name: 'Es Teh', quantity: 1, pricePerItem: 3000),
      ],
      totalPrice: 18000,
      status: OrderStatus.menunggu,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('orders').add(newOrder.toMap());
  }

  // --- FUNGSI CHECKOUT MULTI-TENANT (SPLIT ORDER) ---
  Future<void> createOrderFromCart(
      List<CartItem> cartItems, int totalAmount) async {
    if (cartItems.isEmpty) return;

    // 1. Kelompokkan item berdasarkan Nama Toko (Tenant)
    // Map<NamaToko, List<ItemBelanja>>
    final Map<String, List<CartItem>> itemsByTenant = {};

    for (var item in cartItems) {
      if (!itemsByTenant.containsKey(item.tenant)) {
        itemsByTenant[item.tenant] = [];
      }
      itemsByTenant[item.tenant]!.add(item);
    }

    // 2. Buat Order terpisah untuk setiap Toko
    // Kita gunakan Future.wait agar semua upload berjalan paralel (cepat)
    final List<Future> uploadTasks = [];

    itemsByTenant.forEach((tenantName, items) {
      // Hitung total harga KHUSUS untuk toko ini saja
      int tenantTotal =
          items.fold(0, (sum, item) => sum + (item.price * item.quantity));

      // Konversi ke OrderItem database
      final List<OrderItem> orderItems = items.map((ci) {
        return OrderItem(
          name: ci.notes.isEmpty ? ci.menuName : "${ci.menuName} (${ci.notes})",
          quantity: ci.quantity,
          pricePerItem: ci.price,
        );
      }).toList();

      // Buat Object Order
      final newOrder = Order(
        id: '',
        tenant: tenantName, // Nama toko sudah sesuai grouping
        items: orderItems,
        totalPrice: tenantTotal, // Total harga per toko
        status: OrderStatus.menunggu,
        createdAt: DateTime.now(),
      );

      // Masukkan antrian upload ke Firebase
      uploadTasks.add(_firestore.collection('orders').add(newOrder.toMap()));
    });

    // 3. Eksekusi semua upload
    await Future.wait(uploadTasks);
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus.name,
      });
      // Tidak perlu notifyListeners() manual karena listener stream akan otomatis mendeteksi perubahan
    } catch (e) {
      print("Error updating status: $e");
      rethrow;
    }
  }
}
