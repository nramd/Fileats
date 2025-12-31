import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic> menu;
  
  // TAMBAHAN: Parameter Opsional untuk Mode Edit
  final String? cartItemId; 
  final String? initialNote;

  const MenuDetailScreen({
    Key? key, 
    required this.menu,
    this.cartItemId, // Jika diisi, berarti Mode Edit
    this.initialNote,
  }) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    // Isi catatan jika ada (Mode Edit)
    _noteController = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    // Cek apakah ini Mode Edit
    final isEditMode = widget.cartItemId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Pesanan" : menu['name'], 
            style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GAMBAR
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
                        Row(
                          children: [
                            Icon(Icons.store, size: 16, color: Colors.grey),
                            SizedBox(width: 5),
                            Text(menu['tenant'], style: TextStyle(color: Colors.grey, fontFamily: "Gabarito")),
                          ],
                        ),
                        SizedBox(height: 10),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(menu['name'], style: TextStyle(fontFamily: "Gabarito", fontSize: 24, fontWeight: FontWeight.bold))),
                            Text("Rp ${menu['price']}", style: TextStyle(fontFamily: "Gabarito", fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffED831F))),
                          ],
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 10),

                        Text("Catatan Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
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

          // TOMBOL AKSI
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
                  if (isEditMode) {
                    // LOGIC UPDATE (EDIT MODE)
                    Provider.of<CartProvider>(context, listen: false).updateNote(
                      widget.cartItemId!,
                      _noteController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Catatan diperbarui!")));
                  } else {
                    // LOGIC ADD (NORMAL MODE)
                    Provider.of<CartProvider>(context, listen: false).addItem(
                      menu['name'], 
                      menu['name'], 
                      menu['price'], 
                      menu['tenant'],
                      menu['image'], // Kirim Image
                      _noteController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Masuk keranjang!"), backgroundColor: Colors.green));
                  }
                  
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffED831F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isEditMode ? "Simpan Perubahan" : "Tambah ke Keranjang", 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}