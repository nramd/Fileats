import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/order_provider.dart';
import '../../../data/models/order_model.dart';
import '../../widgets/common/custom_button.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String?  orderId;

  const OrderTrackingScreen({super.key, this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final order = orderProvider.currentOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pesanan')),
        body: const Center(child: Text('Pesanan tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Status Pesanan'),
        backgroundColor:  AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons. close),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/buyer-main',
              (route) => false,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingScreen),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(order),
            const SizedBox(height: 24),
            // Timeline
            _buildTimeline(order),
            const SizedBox(height: 24),
            // Order Details
            _buildOrderDetails(order),
            const SizedBox(height: 24),
            // Action Button
            if (order.status == AppConstants.orderReady)
              CustomButton(
                text: 'Sudah Diambil',
                onPressed:  () {
                  // In real app, this would update order status
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/buyer-main',
                    (route) => false,
                  );
                },
                type: ButtonType.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(OrderModel order) {
    final statusColor = Helpers.getOrderStatusColor(order.status);
    final statusText = Helpers. getOrderStatusText(order.status);

    IconData statusIcon;
    String statusMessage;

    switch (order.status) {
      case AppConstants. orderPending:
        statusIcon = Icons.hourglass_empty;
        statusMessage = 'Menunggu konfirmasi dari penjual';
        break;
      case AppConstants.orderConfirmed:
        statusIcon = Icons.thumb_up;
        statusMessage = 'Pesanan dikonfirmasi, akan segera diproses';
        break;
      case AppConstants.orderPreparing:
        statusIcon = Icons.restaurant;
        statusMessage = 'Pesanan sedang disiapkan';
        break;
      case AppConstants.orderReady:
        statusIcon = Icons.check_circle;
        statusMessage = 'Pesanan siap!  Silakan ambil di kantin';
        break;
      case AppConstants.orderCompleted:
        statusIcon = Icons.done_all;
        statusMessage = 'Pesanan selesai.  Terima kasih!';
        break;
      default:
        statusIcon = Icons. info;
        statusMessage = 'Status tidak diketahui';
    }

    return Container(
      padding: const EdgeInsets. all(24),
      decoration: BoxDecoration(
        color: AppColors. white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Icon
          Container(
            padding:  const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: statusColor. withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 48, color: statusColor),
          ),
          const SizedBox(height:  16),
          // Status Text
          Text(statusText, style: AppTypography. heading5),
          const SizedBox(height: 8),
          Text(
            statusMessage,
            style:  AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Estimated Time
          if (order.status != AppConstants.orderCompleted &&
              order.status != AppConstants.orderCancelled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical:  8),
              decoration: BoxDecoration(
                color: AppColors.accent400.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, size: 18, color: AppColors.primary900),
                  const SizedBox(width: 8),
                  Text(
                    'Estimasi: ${order.estimatedMinutes} menit',
                    style: AppTypography.labelMedium.copyWith(color: AppColors.primary900),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderModel order) {
    final steps = [
      {'status': AppConstants.orderPending, 'label': 'Pesanan Dibuat', 'icon': Icons.receipt},
      {'status': AppConstants.orderConfirmed, 'label': 'Dikonfirmasi', 'icon':  Icons.thumb_up},
      {'status':  AppConstants.orderPreparing, 'label': 'Diproses', 'icon': Icons.restaurant},
      {'status':  AppConstants.orderReady, 'label': 'Siap Diambil', 'icon': Icons.check_circle},
    ];

    int currentStep = steps.indexWhere((s) => s['status'] == order.status);
    if (currentStep == -1) currentStep = 0;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: AppColors. white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress Pesanan', style: AppTypography. labelLarge),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isCompleted = index <= currentStep;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Line
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:  isCompleted ? AppColors.primary900 : AppColors.grey200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        size: 16,
                        color: isCompleted ? AppColors.white : AppColors.grey400,
                      ),
                    ),
                    if (! isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: isCompleted ? AppColors.primary900 : AppColors.grey200,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Label
                Expanded(
                  child:  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      step['label'] as String,
                      style: AppTypography.bodyMedium. copyWith(
                        color:  isCompleted ? AppColors.primary900 : AppColors.grey400,
                        fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order) {
    return Container(
      padding:  const EdgeInsets.all(AppConstants.paddingCard),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detail Pesanan', style: AppTypography.labelLarge),
          const SizedBox(height: 16),
          // Order ID
          _buildDetailRow('ID Pesanan', '#${order.id. substring(0, 8).toUpperCase()}'),
          _buildDetailRow('Tenant', order.tenantName),
          _buildDetailRow('Pembayaran', order.paymentMethod. toUpperCase()),
          _buildDetailRow('Waktu Pesan', Helpers.formatDateTime(order.createdAt)),
          const Divider(height: 24),
          // Items
          ... order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text('${item.quantity}x ', style: AppTypography.labelMedium),
                Expanded(child: Text(item.menuItemName, style: AppTypography.bodyMedium)),
                Text(Helpers.formatCurrency(item. totalPrice), style: AppTypography. bodyMedium),
              ],
            ),
          )),
          const Divider(height: 24),
          _buildDetailRow('Subtotal', Helpers.formatCurrency(order.subtotal)),
          _buildDetailRow('Biaya Layanan', Helpers.formatCurrency(order.serviceFee)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text('Total', style: AppTypography.labelLarge),
              Text(
                Helpers.formatCurrency(order.totalAmount),
                style: AppTypography.heading6.copyWith(color: AppColors.primary900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets. only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Text(label, style: AppTypography.bodySmall. copyWith(color: AppColors. grey600)),
          Text(value, style: AppTypography.labelMedium),
        ],
      ),
    );
  }
}