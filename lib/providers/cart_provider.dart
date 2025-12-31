import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // PENTING: Import dari model, jangan buat class baru

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

  // FUNGSI ADD ITEM (Updated: Terima parameter notes)
  void addItem(String menuId, String name, int price, String tenantName, [String notes = '']) {
    if (_items.containsKey(menuId)) {
      // Jika barang sudah ada, tambah jumlahnya
      // Catatan: Biasanya kalau tambah qty, notes ikut yang lama atau diupdate. 
      // Disini kita biarkan notes yang lama.
      _items.update(
        menuId,
        (existing) => CartItem(
          id: existing.id,
          menuName: existing.menuName,
          tenant: existing.tenant,
          price: existing.price,
          quantity: existing.quantity + 1,
          notes: existing.notes, // Pertahankan notes lama
        ),
      );
    } else {
      // Jika barang baru, masukkan beserta notes-nya
      _items.putIfAbsent(
        menuId,
        () => CartItem(
          id: DateTime.now().toString(),
          menuName: name, // Pakai menuName sesuai model
          tenant: tenantName,
          price: price,
          quantity: 1,
          notes: notes, // Simpan Notes
        ),
      );
    }
    notifyListeners();
  }

  // FUNGSI KURANGI ITEM (Dikembalikan karena CartScreen butuh ini)
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
        ),
      );
    } else {
      _items.remove(menuId);
    }
    notifyListeners();
  }

  // Hapus item total
  void removeItem(String menuId) {
    _items.remove(menuId);
    notifyListeners();
  }

  // Bersihkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }
}