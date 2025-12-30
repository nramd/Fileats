import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/order_model.dart';
import '../core/constants/app_constants.dart';
import 'cart_provider.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _buyerOrders = [];
  List<OrderModel> _sellerOrders = [];
  OrderModel?  _currentOrder;
  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> get buyerOrders => _buyerOrders;
  List<OrderModel> get sellerOrders => _sellerOrders;
  OrderModel?  get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Seller statistics
  double get todayRevenue {
    final today = DateTime.now();
    return _sellerOrders
        .where((o) => o.status == AppConstants.orderCompleted && 
                      o.completedAt != null && 
                      _isSameDay(o.completedAt!, today))
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get weeklyRevenue {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _sellerOrders
        .where((o) => o.status == AppConstants. orderCompleted && 
                      o.completedAt != null && 
                      o.completedAt!.isAfter(weekAgo))
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  int get todayOrdersCount {
    final today = DateTime.now();
    return _sellerOrders. where((o) => _isSameDay(o.createdAt, today)).length;
  }

  List<OrderModel> get inProgressOrders => _sellerOrders
      . where((o) => o.status != AppConstants.orderCompleted && 
                    o.status != AppConstants.orderCancelled)
      .toList();

  List<OrderModel> get completedOrders => _sellerOrders
      .where((o) => o.status == AppConstants.orderCompleted || 
                    o.status == AppConstants.orderCancelled)
      .toList();

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b. year && a.month == b. month && a.day == b. day;

  // Create Order
  Future<OrderModel?> createOrder({
    required String buyerId,
    required String buyerName,
    required CartProvider cartProvider,
    required String paymentMethod,
    String? notes,
  }) async {
    if (cartProvider.isEmpty || cartProvider. currentTenant == null) {
      _errorMessage = 'Keranjang kosong';
      notifyListeners();
      return null;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final tenant = cartProvider.currentTenant! ;
      final items = cartProvider.items.values.map((c) => OrderItem(
        menuItemId:  c.menuItem.id,
        menuItemName: c.menuItem.name,
        price: c.menuItem.price,
        quantity: c.quantity,
        notes: c.notes,
      )).toList();

      final docRef = await _firestore. collection(AppConstants.ordersCollection).add({
        'buyerId': buyerId,
        'buyerName': buyerName,
        'tenantId': tenant. id,
        'tenantName': tenant.name,
        'items': items. map((i) => i.toMap()).toList(),
        'subtotal':  cartProvider.subtotal,
        'serviceFee': cartProvider. serviceFee,
        'totalAmount': cartProvider.totalAmount,
        'status': AppConstants. orderPending,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'estimatedMinutes': cartProvider.estimatedMinutes,
        'notes': notes,
        'createdAt':  Timestamp.now(),
      });

      final newOrder = OrderModel(
        id: docRef.id,
        buyerId: buyerId,
        buyerName: buyerName,
        tenantId: tenant.id,
        tenantName: tenant.name,
        items: items,
        subtotal:  cartProvider.subtotal,
        serviceFee: cartProvider.serviceFee,
        totalAmount:  cartProvider.totalAmount,
        status: AppConstants.orderPending,
        paymentMethod: paymentMethod,
        paymentStatus: 'paid',
        estimatedMinutes:  cartProvider.estimatedMinutes,
        notes: notes,
        createdAt: DateTime.now(),
      );

      _currentOrder = newOrder;
      _buyerOrders.insert(0, newOrder);
      _isLoading = false;
      notifyListeners();
      return newOrder;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Fetch Orders
  Future<void> fetchBuyerOrders(String buyerId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('buyerId', isEqualTo: buyerId)
          .orderBy('createdAt', descending: true)
          .get();
      _buyerOrders = snapshot.docs. map((d) => OrderModel.fromFirestore(d)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchSellerOrders(String tenantId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final snapshot = await _firestore
          . collection(AppConstants.ordersCollection)
          .where('tenantId', isEqualTo: tenantId)
          .orderBy('createdAt', descending:  true)
          .get();
      _sellerOrders = snapshot.docs.map((d) => OrderModel.fromFirestore(d)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update Order Status (Seller)
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final updateData = <String, dynamic>{
        'status': newStatus,
      };
      if (newStatus == AppConstants.orderConfirmed) {
        updateData['confirmedAt'] = Timestamp.now();
      } else if (newStatus == AppConstants.orderCompleted) {
        updateData['completedAt'] = Timestamp. now();
      }

      await _firestore. collection(AppConstants.ordersCollection).doc(orderId).update(updateData);

      final index = _sellerOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _sellerOrders[index] = _sellerOrders[index].copyWith(
          status: newStatus,
          confirmedAt: newStatus == AppConstants.orderConfirmed ? DateTime.now() : null,
          completedAt: newStatus == AppConstants.orderCompleted ? DateTime. now() : null,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void setCurrentOrder(OrderModel order) {
    _currentOrder = order;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}