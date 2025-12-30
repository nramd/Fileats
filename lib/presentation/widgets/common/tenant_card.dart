import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/tenant_model.dart';

class TenantCard extends StatelessWidget {
  final TenantModel tenant;
  final VoidCallback? onTap;

  const TenantCard({
    super.key,
    required this.tenant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.radiusMd),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:  tenant.imageUrl,
                    height: 140,
                    width: double. infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: AppColors.grey200,
                      child: const Center(
                        child: Icon(Icons.store, size: 40, color:  AppColors.grey400),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 140,
                      color: AppColors.grey200,
                      child: const Center(
                        child: Icon(Icons.store, size: 40, color: AppColors.grey400),
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: tenant.isOpen ? AppColors.success : AppColors.grey500,
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      tenant.isOpen ? 'Buka' : 'Tutup',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingCard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tenant.name,
                    style: AppTypography.heading6,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tenant.description,
                    style: AppTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow. ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Rating
                      const Icon(Icons.star, size: 16, color: AppColors.accent400),
                      const SizedBox(width: 4),
                      Text(
                        tenant. rating.toStringAsFixed(1),
                        style: AppTypography.labelMedium,
                      ),
                      Text(
                        ' (${tenant.totalReviews})',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      // Operating hours
                      Icon(Icons.access_time, size: 14, color: AppColors.grey500),
                      const SizedBox(width: 4),
                      Text(
                        '${tenant.openTime} - ${tenant.closeTime}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}