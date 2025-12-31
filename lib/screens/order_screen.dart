import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    orderProvider.seedOrdersIfNeeded(); // Untuk demo/testing

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<OrderProvider>(
        builder: (context, model, child) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: model.orders.length,
          itemBuilder: (context, index) {
            final order = model.orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.tenant,
                        style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Text(order.menu,
                        style: TextStyle(fontFamily: "Gabarito", fontSize: 14, color: Colors.black87)),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rp. ${order.price}",
                            style: TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold)),
                        Chip(
                          label: Text(order.status, style: TextStyle(fontFamily: "Gabarito", color: Colors.white)),
                          backgroundColor: _statusColor(order.status),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Diproses':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}