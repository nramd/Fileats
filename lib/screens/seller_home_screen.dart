import 'package:fileats/main.dart';
import 'package:fileats/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class SellerHomeScreen extends StatefulWidget {
  static const routeName = '/seller-home';
  final String tenantName;

  const SellerHomeScreen({Key? key, required this.tenantName})
      : super(key: key);

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().listenToOrders();
    });
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => FileatSplashh()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildDashboardTab(),
      _buildProfileTab(),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dashboard Penjual",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(widget.tenantName,
                      style: TextStyle(
                          fontFamily: "Gabarito",
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Color(0xffED831F),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Pesanan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.store), label: "Profil Toko"),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              labelColor: Color(0xffED831F),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xffED831F),
              tabs: [
                Tab(text: "Pesanan Masuk"),
                Tab(text: "Sedang Disiapkan"),
              ],
            ),
          ),
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) {
                final myOrders = provider.orders
                    .where((o) => o.tenant == widget.tenantName)
                    .toList();
                final incomingOrders = myOrders
                    .where((o) => o.status == OrderStatus.menunggu)
                    .toList();
                final kitchenOrders = myOrders
                    .where((o) =>
                        o.status == OrderStatus.diproses ||
                        o.status == OrderStatus.diantar)
                    .toList();

                return TabBarView(
                  children: [
                    _buildOrderList(incomingOrders, isIncoming: true),
                    _buildOrderList(kitchenOrders, isIncoming: false),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange.shade100,
                    child: Icon(Icons.store, size: 40, color: Colors.orange),
                  ),
                  SizedBox(height: 10),
                  Text(widget.tenantName,
                      style: TextStyle(
                          fontFamily: "Gabarito",
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text("Mitra FILeats", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text("Ringkasan Penjualan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Consumer<OrderProvider>(builder: (context, provider, _) {
              final finishedOrders = provider.orders
                  .where((o) =>
                      o.tenant == widget.tenantName &&
                      o.status == OrderStatus.selesai)
                  .toList();
              int totalOmzet =
                  finishedOrders.fold(0, (sum, item) => sum + item.totalPrice);
              int totalTrx = finishedOrders.length;

              return Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5))
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatItem("Total Transaksi", "$totalTrx Order"),
                        _buildStatItem("Pendapatan", "Rp $totalOmzet"),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar("Sen", 30),
                        _buildBar("Sel", 50),
                        _buildBar("Rab", 20),
                        _buildBar("Kam", 60),
                        _buildBar("Jum", 80),
                        _buildBar("Sab", 40),
                        _buildBar("Min", 90),
                      ],
                    )
                  ],
                ),
              );
            }),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Keluar Toko",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value,
            style: TextStyle(
                fontFamily: "Gabarito",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff002647))),
      ],
    );
  }

  Widget _buildBar(String day, double height) {
    return Column(
      children: [
        Container(
          width: 10,
          height: height,
          decoration: BoxDecoration(
            color: Color(0xffED831F),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(height: 5),
        Text(day, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOrderList(List<Order> orders, {required bool isIncoming}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 60, color: Colors.grey[300]),
            SizedBox(height: 10),
            Text("Tidak ada pesanan aktif",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: ID Order & Total Harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("#${order.id.substring(0, 4)}...",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Rp ${order.totalPrice}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
                Divider(),

                // LOOP ITEM MAKANAN
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0), // Jarak antar menu diperlega
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Menu & Jumlah
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Pakai Expanded agar nama menu panjang turun ke bawah (tidak error)
                              Expanded(
                                child: Text(
                                  "${item.quantity}x ${item.name}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),

                          // Tampilkan Catatan (FULL TEXT)
                          if (item.note.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0), // Jarak sedikit dari nama menu
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Ikon sejajar dengan baris pertama teks
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 2.0), // Pas kan ikon dengan teks
                                    child: Icon(Icons.edit_note,
                                        size: 16, color: Color(0xffED831F)),
                                  ),
                                  SizedBox(width: 6),
                                  // EXPANDED KUNCI: Membatasi lebar teks agar tidak nabrak kanan,
                                  // tapi membiarkannya turun ke bawah (multiline)
                                  Expanded(
                                    child: Text(
                                      "Catatan: ${item.note}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xffED831F),
                                        fontStyle: FontStyle.italic,
                                        height:
                                            1.3, // Spasi antar baris biar enak dibaca
                                      ),
                                      // KITA HAPUS maxLines & overflow AGAR TAMPIL SEMUA
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )),

                SizedBox(height: 16),

                // TOMBOL AKSI (Terima/Tolak/Selesai)
                Row(
                  children: [
                    if (isIncoming) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<OrderProvider>().updateOrderStatus(
                                order.id, OrderStatus.dibatalkan);
                          },
                          child: Text("Tolak",
                              style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OrderProvider>().updateOrderStatus(
                                order.id, OrderStatus.diproses);
                          },
                          child: Text("Terima"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OrderProvider>().updateOrderStatus(
                                order.id, OrderStatus.selesai);
                          },
                          child: Text("Selesai"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffED831F)),
                        ),
                      ),
                    ]
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
