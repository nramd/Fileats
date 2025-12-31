import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang Saya",
            style:
                TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // TOTAL CARD
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: TextStyle(fontSize: 20, fontFamily: "Gabarito")),
                  Spacer(),
                  Chip(
                    label: Text(
                      'Rp ${cart.totalAmount}',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Gabarito"),
                    ),
                    backgroundColor: Color(0xffED831F),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (cart.items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Keranjang masih kosong!")));
                        return;
                      }

                      try {
                        // OrderProvider akan menerima List<CartItem> yang benar
                        await Provider.of<OrderProvider>(context, listen: false)
                            .createOrderFromCart(
                                cart.items.values.toList(), cart.totalAmount);

                        cart.clear();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Pesanan berhasil dibuat!")));

                        Navigator.of(context).pop();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Gagal membuat pesanan: $error")));
                      }
                    },
                    child: Text("PESAN SEKARANG",
                        style: TextStyle(
                            color: Color(0xffED831F),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          
          // LIST ITEM
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                final item = cart.items.values.toList()[i];
                final productId = cart.items.keys.toList()[i];

                return Dismissible(
                  key: ValueKey(item.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Icon(Icons.delete, color: Colors.white, size: 40),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeItem(productId);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: FittedBox(child: Text('x${item.quantity}')),
                          ),
                        ),
                        // Menggunakan menuName (bukan title)
                        title: Text(item.menuName,
                            style: TextStyle(
                                fontFamily: "Gabarito",
                                fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: Rp ${item.price * item.quantity}'),
                            // Menampilkan Notes jika ada
                            if (item.notes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Catatan: ${item.notes}',
                                  style: TextStyle(
                                      color: Colors.orange[800], // Warna beda biar terlihat
                                      fontSize: 12, 
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                  color: Colors.red),
                              onPressed: () {
                                // Fungsi ini sekarang sudah ada lagi di provider
                                cart.removeSingleItem(productId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline,
                                  color: Colors.green),
                              onPressed: () {
                                // Menambah item (notes dikosongkan/diabaikan saat nambah qty lewat sini)
                                cart.addItem(productId, item.menuName,
                                    item.price, item.tenant);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}