import 'package:flutter/material.dart';
import '../data/models/menu_item_model.dart';
import '../data/models/tenant_model.dart';

class CartItem {
  final MenuItemModel menuItem;
  int quantity;
  String? notes;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice => menuItem.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  TenantModel? _currentTenant;
  static const double _serviceFeePercentage = 0.05; // 5%

  Map<String, CartItem> get items => Map.unmodifiable(_items);
  TenantModel? get currentTenant => _currentTenant;
  
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  
  double get serviceFee => subtotal * _serviceFeePercentage;
  
  double get totalAmount => subtotal + serviceFee;

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items. isNotEmpty;

  int get estimatedMinutes {
    if (_items.isEmpty) return 0;
    // Calculate based on longest preparation time + queue
    int maxPrepTime = _items.values
        .map((item) => item.menuItem.preparationTime)
        .reduce((a, b) => a > b ? a : b);
    return maxPrepTime + (_items.length - 1) * 2; // +2 min for each additional item
  }

  void addItem(MenuItemModel menuItem, TenantModel tenant) {
    // Check if adding from different tenant
    if (_currentTenant != null && _currentTenant!.id != tenant.id) {
      // Clear cart if different tenant
      clearCart();
    }
    
    _currentTenant = tenant;

    if (_items.containsKey(menuItem.id)) {
      _items[menuItem.id]!.quantity++;
    } else {
      _items[menuItem.id] = CartItem(menuItem: menuItem);
    }
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.remove(menuItemId);
    if (_items.isEmpty) {
      _currentTenant = null;
    }
    notifyListeners();
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (!_items.containsKey(menuItemId)) return;

    if (quantity <= 0) {
      removeItem(menuItemId);
    } else {
      _items[menuItemId]!.quantity = quantity;
      notifyListeners();
    }
  }

  void incrementQuantity(String menuItemId) {
    if (_items.containsKey(menuItemId)) {
      _items[menuItemId]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String menuItemId) {
    if (_items.containsKey(menuItemId)) {
      if (_items[menuItemId]! .quantity > 1) {
        _items[menuItemId]!.quantity--;
      } else {
        removeItem(menuItemId);
      }
      notifyListeners();
    }
  }

  void updateNotes(String menuItemId, String notes) {
    if (_items.containsKey(menuItemId)) {
      _items[menuItemId]!.notes = notes;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _currentTenant = null;
    notifyListeners();
  }

  int getItemQuantity(String menuItemId) {
    return _items[menuItemId]?.quantity ?? 0;
  }

  bool hasItem(String menuItemId) {
    return _items.containsKey(menuItemId);
  }
}