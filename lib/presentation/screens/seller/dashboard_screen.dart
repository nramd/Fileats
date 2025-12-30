import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/tenant_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final tenantId = authProvider.currentUser?.tenantId;
    
    if (tenantId != null && tenantId.isNotEmpty) {
      orderProvider.fetchSellerOrders(tenantId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets. all(AppConstants.paddingScreen),
                  color: AppColors.primary900,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:  CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, ${user?.name ?? 'Penjual'}!  👋',
                                style:  AppTypography.heading6. copyWith(color: AppColors. white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kelola toko Anda dengan mudah',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.grey300),
                              ),
                            ],
                          ),
                          // Store Status Toggle
                          _buildStoreToggle(),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Statistics Cards
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingScreen),
                  child: Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text('Ringkasan Hari Ini', style: AppTypography.heading6),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Pendapatan Hari Ini',
                              value:  Helpers.formatCurrency(orderProvider.todayRevenue),
                              icon: Icons.account_balance_wallet,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Pesanan Hari Ini',
                              value: '${orderProvider.todayOrdersCount}',
                              icon: Icons.receipt_long,
                              color:  AppColors.secondary500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        title: 'Pendapatan Minggu Ini',
                        value: Helpers.formatCurrency(orderProvider.weeklyRevenue),
                        icon: Icons.trending_up,
                        color:  AppColors.accent400,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),

                // Recent Orders
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingScreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pesanan Masuk', style: AppTypography. heading6),
                      TextButton(
                        onPressed:  () {
                          // Navigate to order management tab
                        },
                        child: Text(
                          'Lihat Semua',
                          style:  AppTypography.labelMedium.copyWith(color: AppColors.secondary500),
                        ),
                      ),
                    ],
                  ),
                ),

                // In Progress Orders
                if (orderProvider.isLoading)
                  const Center(
                    child:  Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (orderProvider. inProgressOrders.isEmpty)
                  _buildEmptyOrders()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics:  const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.paddingScreen),
                    itemCount: orderProvider. inProgressOrders.length > 5
                        ? 5
                        : orderProvider.inProgressOrders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider. inProgressOrders[index];
                      return _buildOrderCard(order, orderProvider);
                    },
                  ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreToggle() {
    final tenantProvider = context.watch<TenantProvider>();
    final authProvider = context.read<AuthProvider>();
    final tenantId = authProvider.currentUser?.tenantId;
    
    // For demo, we'll use a local state
    bool isOpen = true;

    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors. white. withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isOpen ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOpen ? 'Buka' : 'Tutup',
            style: AppTypography.labelMedium.copyWith(color: AppColors.white),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.white,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets. all(16),
      decoration: BoxDecoration(
        color:  AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color. withOpacity(0.1),
              borderRadius: BorderRadius. circular(AppConstants.radiusMd),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.caption.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography. heading6.copyWith(color: AppColors.primary900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingScreen),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors. white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: AppColors.grey400),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan masuk',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 4),
          Text(
            'Pesanan baru akan muncul di sini',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(order, OrderProvider orderProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow:  [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius:  8,
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
              Text(
                '#${order.id. substring(0, 8).toUpperCase()}',
                style:  AppTypography.labelLarge.copyWith(color: AppColors.primary900),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:  Helpers.getOrderStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
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
          const SizedBox(height: 12),
          // Buyer
          Row(
            children: [
              CircleAvatar(
                radius:  16,
                backgroundColor: AppColors.grey200,
                child: Text(
                  order.buyerName.isNotEmpty ? order.buyerName[0]. toUpperCase() : 'U',
                  style:  AppTypography.labelSmall.copyWith(color: AppColors.primary900),
                ),
              ),
              const SizedBox(width: 8),
              Text(order.buyerName, style: AppTypography.labelMedium),
            ],
          ),
          const Divider(height: 24),
          // Items
          ... order.items.take(3).map<Widget>((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  '${item.quantity}x',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.primary900),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.menuItemName,
                    style: AppTypography.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )).toList(),
          if (order.items.length > 3)
            Text(
              '+${order.items.length - 3} item lainnya',
              style: AppTypography.caption.copyWith(color: AppColors.grey500),
            ),
          const SizedBox(height: 12),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Helpers.formatCurrency(order. totalAmount),
                style: AppTypography.labelLarge.copyWith(color: AppColors.primary900),
              ),
              _buildActionButton(order, orderProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(order, OrderProvider orderProvider) {
    String nextStatus;
    String buttonText;
    Color buttonColor;

    switch (order.status) {
      case AppConstants.orderPending:
        nextStatus = AppConstants.orderConfirmed;
        buttonText = 'Konfirmasi';
        buttonColor = AppColors. info;
        break;
      case AppConstants.orderConfirmed:
        nextStatus = AppConstants. orderPreparing;
        buttonText = 'Mulai Masak';
        buttonColor = AppColors.secondary500;
        break;
      case AppConstants.orderPreparing:
        nextStatus = AppConstants.orderReady;
        buttonText = 'Siap Diambil';
        buttonColor = AppColors.success;
        break;
      case AppConstants.orderReady:
        nextStatus = AppConstants.orderCompleted;
        buttonText = 'Selesai';
        buttonColor = AppColors.primary900;
        break;
      default:
        return const SizedBox. shrink();
    }

    return ElevatedButton(
      onPressed: () => orderProvider.updateOrderStatus(order. id, nextStatus),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
      child: Text(
        buttonText,
        style: AppTypography.labelMedium. copyWith(color: AppColors. white),
      ),
    );
  }
}