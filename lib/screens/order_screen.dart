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
    // Panggil listenToOrders saat halaman dibuka
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
          title: Text("Pesanan Saya", style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: "Dalam Proses"),
              Tab(text: "Riwayat"),
            ],
          ),
          actions: [
            // TOMBOL TEST: Klik ini untuk nambah data ke Firebase
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.orange),
              onPressed: () {
                context.read<OrderProvider>().addDummyOrder();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Menambahkan pesanan test ke Firebase..."))
                );
              },
            )
          ],
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
      return Center(child: Text("Belum ada pesanan", style: TextStyle(fontFamily: "Gabarito")));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.tenant,
                        style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Divider(),
                Text(order.menuSummary, 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: "Gabarito", fontSize: 14, color: Colors.black87)),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rp ${order.totalPrice}",
                        style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold, fontSize: 16)),
                    Chip(
                      label: Text(
                        order.status.name.toUpperCase(), 
                        style: TextStyle(fontFamily: "Gabarito", color: Colors.white, fontSize: 10),
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

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.selesai:
        return Colors.green;
      case OrderStatus.dibatalkan:
        return Colors.red;
      case OrderStatus.diproses:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}