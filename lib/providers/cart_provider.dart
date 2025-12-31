import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  int get totalAmount {
    var total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // UPDATE: Terima parameter image
  void addItem(String menuId, String name, int price, String tenantName, String image, [String notes = '']) {
    if (_items.containsKey(menuId)) {
      _items.update(
        menuId,
        (existing) => CartItem(
          id: existing.id,
          menuName: existing.menuName,
          tenant: existing.tenant,
          price: existing.price,
          quantity: existing.quantity + 1,
          notes: existing.notes,
          image: existing.image, // Pertahankan gambar
        ),
      );
    } else {
      _items.putIfAbsent(
        menuId,
        () => CartItem(
          id: DateTime.now().toString(),
          menuName: name,
          tenant: tenantName,
          price: price,
          quantity: 1,
          notes: notes,
          image: image, // Simpan gambar baru
        ),
      );
    }
    notifyListeners();
  }

  // BARU: Fungsi Khusus Edit Catatan
  void updateNote(String menuId, String newNote) {
    if (_items.containsKey(menuId)) {
      _items.update(
        menuId,
        (existing) => CartItem(
          id: existing.id,
          menuName: existing.menuName,
          tenant: existing.tenant,
          price: existing.price,
          quantity: existing.quantity,
          image: existing.image,
          notes: newNote, // Update Catatan Saja
        ),
      );
      notifyListeners();
    }
  }

  void removeSingleItem(String menuId) {
    if (!_items.containsKey(menuId)) return;
    if (_items[menuId]!.quantity > 1) {
      _items.update(
        menuId,
        (existing) => CartItem(
          id: existing.id,
          menuName: existing.menuName,
          tenant: existing.tenant,
          price: existing.price,
          quantity: existing.quantity - 1,
          notes: existing.notes,
          image: existing.image,
        ),
      );
    } else {
      _items.remove(menuId);
    }
    notifyListeners();
  }

  void removeItem(String menuId) {
    _items.remove(menuId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}