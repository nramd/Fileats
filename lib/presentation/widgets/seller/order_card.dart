import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final void Function(String)? onUpdateStatus;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets. only(bottom: AppConstants.spacingMd),
        padding: const EdgeInsets.all(AppConstants.paddingCard),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius. circular(AppConstants.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors. grey300.withOpacity(0.5),
              blurRadius: 8,
              offset:  const Offset(0, 2),
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
                  style: AppTypography.labelLarge. copyWith(
                    color: AppColors.primary900,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            // Buyer info
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.grey200,
                  child: Icon(Icons.person, size: 18, color: AppColors.grey500),
                ),
                const SizedBox(width: 8),
                Text(order.buyerName, style: AppTypography.labelMedium),
              ],
            ),
            const SizedBox(height: 12),
            // Items
            ... order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.menuItemName,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  Text(
                    Helpers.formatCurrency(item.totalPrice),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            )),
            const Divider(height: 24),
            // Total & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: AppTypography. caption),
                    Text(
                      Helpers.formatCurrency(order.totalAmount),
                      style: AppTypography.labelLarge. copyWith(
                        color:  AppColors.primary900,
                      ),
                    ),
                  ],
                ),
                if (_canUpdateStatus()) _buildActionButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:  Helpers.getOrderStatusColor(order.status).withOpacity(0.1),
        borderRadius: BorderRadius. circular(AppConstants.radiusFull),
        border: Border.all(
          color: Helpers.getOrderStatusColor(order.status),
          width: 1,
        ),
      ),
      child: Text(
        Helpers.getOrderStatusText(order.status),
        style: AppTypography.labelSmall.copyWith(
          color: Helpers.getOrderStatusColor(order. status),
        ),
      ),
    );
  }

  bool _canUpdateStatus() {
    return order.status != AppConstants.orderCompleted &&
           order.status != AppConstants.orderCancelled;
  }

  Widget _buildActionButton() {
    String nextStatus;
    String buttonText;

    switch (order.status) {
      case AppConstants.orderPending:
        nextStatus = AppConstants.orderConfirmed;
        buttonText = 'Konfirmasi';
        break;
      case AppConstants.orderConfirmed:
        nextStatus = AppConstants.orderPreparing;
        buttonText = 'Mulai Masak';
        break;
      case AppConstants.orderPreparing:
        nextStatus = AppConstants.orderReady;
        buttonText = 'Siap Diambil';
        break;
      case AppConstants.orderReady:
        nextStatus = AppConstants. orderCompleted;
        buttonText = 'Selesai';
        break;
      default:
        return const SizedBox. shrink();
    }

    return ElevatedButton(
      onPressed: () => onUpdateStatus?.call(nextStatus),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary900,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        ),
      ),
      child: Text(
        buttonText,
        style: AppTypography.labelMedium. copyWith(color: AppColors.white),
      ),
    );
  }
}