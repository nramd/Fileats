import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuDetailScreen extends StatefulWidget {
  // Kita menerima data menu lewat Constructor
  final Map<String, dynamic> menu;

  const MenuDetailScreen({Key? key, required this.menu}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return Scaffold(
      // AppBar Transparan agar gambar terlihat full di atas (Opsional, tapi biar estetik kita pakai standar saja dulu)
      appBar: AppBar(
        title: Text(menu['name'], style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 1. GAMBAR MAKANAN BESAR
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: AssetImage(menu['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Toko
                        Row(
                          children: [
                            Icon(Icons.store, size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(menu['tenant'], style: TextStyle(color: Colors.grey, fontFamily: "Gabarito")),
                          ],
                        ),
                        SizedBox(height: 10),
                        
                        // Nama Makanan & Harga
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                menu['name'],
                                style: TextStyle(fontFamily: "Gabarito", fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Rp ${menu['price']}",
                              style: TextStyle(fontFamily: "Gabarito", fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffED831F)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 10),

                        // Input Catatan
                        Text("Catatan Pesanan (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: "Cth: Jangan pedas, banyakin kecap...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. TOMBOL TAMBAH DI BAWAH
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // LOGIC TAMBAH KE KERANJANG DENGAN CATATAN
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    menu['name'], // ID
                    menu['name'], // Title
                    menu['price'], // Price
                    menu['tenant'], // Tenant
                    _noteController.text, // NOTE (Catatan dari input)
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Berhasil ditambahkan ke keranjang!"),
                    duration: Duration(seconds: 1),
                    backgroundColor: Colors.green,
                  ));
                  
                  Navigator.pop(context); // Kembali ke Home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffED831F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Tambah ke Keranjang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}