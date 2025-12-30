import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/menu_item_model.dart';

class MenuCard extends StatelessWidget {
  final MenuItemModel menuItem;
  final int quantity;
  final VoidCallback?  onAdd;
  final VoidCallback?  onRemove;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this. menuItem,
    this.quantity = 0,
    this.onAdd,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingCard),
        decoration: BoxDecoration(
          color: AppColors. white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          boxShadow: [
            BoxShadow(
              color:  AppColors.grey300.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: CachedNetworkImage(
                imageUrl: menuItem.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit. cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.grey200,
                  child: const Icon(Icons.restaurant, color: AppColors.grey400),
                ),
                errorWidget: (context, url, error) => Container(
                  width:  80,
                  height:  80,
                  color:  AppColors.grey200,
                  child: const Icon(Icons. restaurant, color: AppColors.grey400),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height:  4),
                  Text(
                    menuItem.description,
                    style: AppTypography.bodySmall,
                    maxLines:  2,
                    overflow:  TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Helpers.formatCurrency(menuItem.price),
                        style: AppTypography. labelLarge. copyWith(
                          color:  AppColors.primary900,
                        ),
                      ),
                      // Quantity controls
                      if (menuItem.isAvailable)
                        _buildQuantityControl()
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Habis',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
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

  Widget _buildQuantityControl() {
    if (quantity == 0) {
      return GestureDetector(
        onTap: onAdd,
        child: Container(
          padding: const EdgeInsets. symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary900,
            borderRadius: BorderRadius. circular(AppConstants.radiusSm),
          ),
          child: Text(
            'Tambah',
            style: AppTypography. labelMedium.copyWith(color: AppColors.white),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.remove, size: 18, color: AppColors.primary900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style:  AppTypography.labelMedium.copyWith(color: AppColors.primary900),
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding:  const EdgeInsets.all(8),
              child: const Icon(Icons.add, size: 18, color: AppColors.primary900),
            ),
          ),
        ],
      ),
    );
  }
}