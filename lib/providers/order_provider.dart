import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void seedOrdersIfNeeded() {
    if (_orders.isEmpty) {
      _orders.addAll([
        Order(
          tenant: 'Lalapan Mbak Elly',
          menu: 'Nasi Usus x2',
          price: 24000,
          status: 'Selesai',
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
        Order(
          tenant: 'Warung Bangdor',
          menu: 'Nasi Goreng x1, Nasi Gila x1',
          price: 25000,
          status: 'Menunggu',
          createdAt: DateTime.now(),
        ),
      ]);
      notifyListeners();
    }
  }
}