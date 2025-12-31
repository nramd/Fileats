import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil listenToOrders saat halaman dibuka agar data Real-time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().listenToOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Pesanan Saya",
              style: TextStyle(
                  fontFamily: "Gabarito", fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Color(0xffED831F), // Sesuaikan warna oranye Fileats
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xffED831F),
            tabs: [
              Tab(text: "Dalam Proses"),
              Tab(text: "Riwayat"),
            ],
          ),
          // BAGIAN ACTIONS (TOMBOL TEST) SUDAH DIHAPUS KARENA TIDAK DIPERLUKAN LAGI
        ),
        body: Consumer<OrderProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: [
                _buildOrderList(provider.activeOrders),
                _buildOrderList(provider.historyOrders),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_outlined, size: 60, color: Colors.grey[300]),
            SizedBox(height: 10),
            Text("Belum ada pesanan",
                style: TextStyle(fontFamily: "Gabarito", color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.tenant,
                        style: TextStyle(
                            fontFamily: "Gabarito",
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Divider(),

                // PERBAIKAN: Tampilkan Item + Catatan secara detail
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Menu
                          Text("${item.quantity}x ${item.name}",
                              style: TextStyle(
                                  fontFamily: "Gabarito",
                                  fontSize: 14,
                                  color: Colors.black87)),

                          // Catatan (Muncul hanya jika ada isinya)
                          if (item.note.isNotEmpty)
                            Text(
                              "Catatan: ${item.note}",
                              style: TextStyle(
                                  fontFamily: "Gabarito",
                                  fontSize: 12,
                                  color: Colors
                                      .orange, // Warna Oranye agar pembeli sadar
                                  fontStyle: FontStyle.italic),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    )),

                SizedBox(height: 4), // Jarak sedikit sebelum total
                Divider(color: Colors.grey[200]), // Garis pemisah tipis

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rp ${order.totalPrice}",
                        style: TextStyle(
                            fontFamily: "Gabarito",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xffED831F))),
                    Chip(
                      label: Text(
                        _statusToString(order.status),
                        style: TextStyle(
                            fontFamily: "Gabarito",
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: _statusColor(order.status),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  // Helper untuk mengubah Enum Status menjadi Teks yang enak dibaca
  String _statusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.menunggu:
        return "MENUNGGU";
      case OrderStatus.diproses:
        return "DIPROSES";
      case OrderStatus.diantar:
        return "SIAP DIAMBIL";
      case OrderStatus.selesai:
        return "SELESAI";
      case OrderStatus.dibatalkan:
        return "DIBATALKAN";
    }
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return Colors.green;
      case OrderStatus.dibatalkan:
        return Colors.red;
      case OrderStatus.diproses:
        return Colors.blue;
      case OrderStatus.diantar:
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}
