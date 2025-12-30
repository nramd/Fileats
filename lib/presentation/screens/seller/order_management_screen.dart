import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order_model.dart';
import '../../widgets/seller/order_card.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
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
    final tenantId = authProvider.currentUser?.tenantId;
    
    if (tenantId != null && tenantId.isNotEmpty) {
      orderProvider.fetchSellerOrders(tenantId);
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
        title: const Text('Manajemen Pesanan'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary900,
          unselectedLabelColor:  AppColors.grey500,
          indicatorColor: AppColors.primary900,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Dalam Proses'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder:  (context, orderProvider, child) {
          if (orderProvider. isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller:  _tabController,
            children:  [
              _buildOrderList(
                orderProvider. inProgressOrders,
                orderProvider,
                emptyMessage: 'Tidak ada pesanan dalam proses',
              ),
              _buildOrderList(
                orderProvider.completedOrders,
                orderProvider,
                emptyMessage: 'Belum ada pesanan selesai',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
    List<OrderModel> orders,
    OrderProvider orderProvider, {
    required String emptyMessage,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.grey400),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingScreen),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onUpdateStatus: (newStatus) {
              orderProvider. updateOrderStatus(order.id, newStatus);
            },
            onTap: () => _showOrderDetail(order),
          );
        },
      ),
    );
  }

  void _showOrderDetail(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Pesanan',
                    style: AppTypography.heading6,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment. start,
                  children: [
                    // Order ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${order.id.substring(0, 8).toUpperCase()}',
                          style: AppTypography.heading6.copyWith(color: AppColors. primary900),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:  Helpers.getOrderStatusColor(order.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                          ),
                          child: Text(
                            Helpers.getOrderStatusText(order.status),
                            style: AppTypography.labelMedium.copyWith(
                              color: Helpers.getOrderStatusColor(order.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Buyer Info
                    Text('Informasi Pembeli', style: AppTypography.labelLarge),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary900,
                            child: Text(
                              order.buyerName.isNotEmpty ? order. buyerName[0].toUpperCase() : 'U',
                              style: AppTypography. labelLarge.copyWith(color: AppColors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment:  CrossAxisAlignment.start,
                            children: [
                              Text(order.buyerName, style: AppTypography.labelMedium),
                              Text(
                                'Dipesan:  ${Helpers.formatDateTime(order.createdAt)}',
                                style: AppTypography.caption.copyWith(color: AppColors.grey600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Items
                    Text('Item Pesanan', style: AppTypography.labelLarge),
                    const SizedBox(height:  12),
                    ...order.items.map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration:  BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius. circular(AppConstants.radiusSm),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary900,
                              borderRadius:  BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: AppTypography. labelSmall.copyWith(color: AppColors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.menuItemName, style: AppTypography.labelMedium),
                                if (item.notes != null && item.notes!.isNotEmpty)
                                  Text(
                                    'Catatan: ${item.notes}',
                                    style:  AppTypography.caption. copyWith(color: AppColors. grey600),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            Helpers.formatCurrency(item.totalPrice),
                            style: AppTypography.labelMedium,
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    // Notes
                    if (order.notes != null && order.notes!.isNotEmpty) ...[
                      Text('Catatan Pesanan', style:  AppTypography.labelLarge),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration:  BoxDecoration(
                          color: AppColors.accent400. withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                          border: Border.all(color: AppColors.accent400.withOpacity(0.3)),
                        ),
                        child: Text(order.notes!, style: AppTypography.bodyMedium),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Payment Summary
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Subtotal', Helpers.formatCurrency(order.subtotal)),
                    _buildSummaryRow('Biaya Layanan', Helpers.formatCurrency(order.serviceFee)),
                    _buildSummaryRow('Metode Bayar', order.paymentMethod. toUpperCase()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.labelLarge),
                        Text(
                          Helpers.formatCurrency(order.totalAmount),
                          style: AppTypography.heading6.copyWith(color: AppColors. primary900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall. copyWith(color: AppColors. grey600)),
          Text(value, style: AppTypography.labelMedium),
        ],
      ),
    );
  }
}