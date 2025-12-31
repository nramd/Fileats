import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'menu_detail_screen.dart'; // Import ini untuk fitur Edit Pesanan

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Background agak abu agar Card menonjol
      appBar: AppBar(
        title: Text(
          "Keranjang Saya",
          style: TextStyle(
            fontFamily: "Gabarito", 
            fontWeight: FontWeight.bold, 
            color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 1. LIST ITEM (MENGISI RUANG TENGAH)
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                        SizedBox(height: 10),
                        Text("Keranjang kosong", style: TextStyle(fontFamily: "Gabarito", color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(top: 15, bottom: 20, left: 15, right: 15),
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final item = cart.items.values.toList()[i];
                      final productId = cart.items.keys.toList()[i];

                      return Dismissible(
                        key: ValueKey(item.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          Provider.of<CartProvider>(context, listen: false).removeItem(productId);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              )
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              // FITUR EDIT: Buka MenuDetailScreen saat diklik
                              // Kita rakit ulang data menu dari item keranjang
                              final menuMap = {
                                'name': item.menuName,
                                'price': item.price,
                                'tenant': item.tenant,
                                'image': item.image, // Pastikan CartItem punya field image
                              };
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuDetailScreen(
                                    menu: menuMap,
                                    cartItemId: productId,
                                    initialNote: item.notes,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // GAMBAR KECIL (Thumbnail)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      item.image, 
                                      width: 70, 
                                      height: 70, 
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                        Container(width: 70, height: 70, color: Colors.grey[200]),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  
                                  // INFO MENU
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.menuName, 
                                          style: TextStyle(
                                            fontFamily: "Gabarito", 
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 16
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "Rp ${item.price * item.quantity}", 
                                          style: TextStyle(
                                            fontFamily: "Gabarito", 
                                            color: Color(0xffED831F), 
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                        
                                        // TAMPILKAN CATATAN
                                        if (item.notes.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              'Note: ${item.notes}',
                                              style: TextStyle(
                                                color: Colors.grey, 
                                                fontSize: 12, 
                                                fontStyle: FontStyle.italic
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // TOMBOL PLUS MINUS
                                  Row(
                                    children: [
                                      _buildQtyBtn(Icons.remove, () {
                                        cart.removeSingleItem(productId);
                                      }),
                                      SizedBox(width: 10),
                                      Text(
                                        '${item.quantity}', 
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                      ),
                                      SizedBox(width: 10),
                                      _buildQtyBtn(Icons.add, () {
                                        // Menggunakan parameter lengkap sesuai CartProvider terbaru
                                        cart.addItem(
                                          productId, 
                                          item.menuName, 
                                          item.price, 
                                          item.tenant, 
                                          item.image
                                        );
                                      }),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 2. BOTTOM CHECKOUT SECTION (PANEL BAWAH MODERN)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                )
              ],
            ),
            child: SafeArea( // Agar aman di iPhone yang ada poni/home bar
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Baris Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pembayaran", 
                        style: TextStyle(
                          fontFamily: "Gabarito", 
                          color: Colors.grey, 
                          fontSize: 14
                        )
                      ),
                      Text(
                        "Rp ${cart.totalAmount}", 
                        style: TextStyle(
                          fontFamily: "Gabarito", 
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Tombol Pesan Besar (Full Width)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Cek keranjang kosong
                        if (cart.items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Keranjang masih kosong!"))
                          );
                          return;
                        }
              
                        try {
                          // 1. Panggil OrderProvider
                          await Provider.of<OrderProvider>(context, listen: false)
                              .createOrderFromCart(
                                  cart.items.values.toList(), cart.totalAmount);
              
                          // 2. Bersihkan Keranjang
                          cart.clear();
              
                          // 3. Feedback & Navigasi
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Pesanan berhasil dibuat!"),
                            backgroundColor: Colors.green,
                          ));
                          
                          Navigator.of(context).pop(); // Kembali ke Home
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Gagal: $error")
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffED831F), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        elevation: 5,
                        shadowColor: Color(0xffED831F).withOpacity(0.4),
                      ),
                      child: Text(
                        "Pesan Sekarang",
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          fontFamily: "Gabarito", 
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget helper untuk tombol +/- agar rapi
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 16, color: Color(0xffED831F)),
      ),
    );
  }
}