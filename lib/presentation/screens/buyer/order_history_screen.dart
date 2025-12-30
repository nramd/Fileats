import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchOrders();
  }

  void _fetchOrders() {
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final userId = authProvider.currentUser?.uid;
    if (userId != null) {
      orderProvider.fetchBuyerOrders(userId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary900,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary900,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text:  'Riwayat'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder:  (context, orderProvider, child) {
          if (orderProvider. isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final activeOrders = orderProvider.buyerOrders
              .where((o) =>
                  o.status != AppConstants.orderCompleted &&
                  o.status != AppConstants.orderCancelled)
              .toList();

          final historyOrders = orderProvider.buyerOrders
              .where((o) =>
                  o. status == AppConstants.orderCompleted ||
                  o.status == AppConstants.orderCancelled)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(activeOrders, isEmpty: 'Tidak ada pesanan aktif'),
              _buildOrderList(historyOrders, isEmpty: 'Belum ada riwayat pesanan'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders, {required String isEmpty}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(isEmpty, style: AppTypography.bodyMedium. copyWith(color: AppColors. grey600)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingScreen),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () {
        context.read<OrderProvider>().setCurrentOrder(order);
        Navigator. pushNamed(context, '/order-tracking');
      },
      child:  Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.paddingCard),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Row(
                  children: [
                    const Icon(Icons.store, size: 18, color: AppColors.primary900),
                    const SizedBox(width: 8),
                    Text(order.tenantName, style: AppTypography.labelMedium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:  Helpers.getOrderStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius. circular(AppConstants.radiusFull),
                  ),
                  child: Text(
                    Helpers.getOrderStatusText(order.status),
                    style: AppTypography.caption.copyWith(
                      color: Helpers.getOrderStatusColor(order.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // Items preview
            Text(
              order.items.map((i) => '${i.quantity}x ${i.menuItemName}').join(', '),
              style: AppTypography. bodySmall. copyWith(color: AppColors. grey600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Helpers.formatDateTime(order.createdAt),
                  style: AppTypography. caption.copyWith(color: AppColors.grey500),
                ),
                Text(
                  Helpers.formatCurrency(order.totalAmount),
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}