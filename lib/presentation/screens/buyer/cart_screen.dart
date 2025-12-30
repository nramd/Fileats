import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/cart_provider.dart';
import '../../widgets/common/custom_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        actions: [
          if (cartProvider.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(context, cartProvider),
              child: Text(
                'Hapus Semua',
                style: AppTypography.labelMedium. copyWith(color: AppColors. error),
              ),
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // Tenant Info
                Container(
                  padding: const EdgeInsets. all(AppConstants. paddingScreen),
                  color: AppColors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent400. withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.store, color: AppColors.primary900, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:  CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartProvider.currentTenant?.name ?? '',
                              style: AppTypography.labelLarge,
                            ),
                            Text(
                              'Estimasi:  ${cartProvider.estimatedMinutes} menit',
                              style: AppTypography.caption.copyWith(color: AppColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Cart Items
                Expanded(
                  child:  ListView. builder(
                    padding: const EdgeInsets.all(AppConstants.paddingScreen),
                    itemCount: cartProvider.items. length,
                    itemBuilder:  (context, index) {
                      final cartItem = cartProvider.items.values.toList()[index];
                      return _buildCartItem(context, cartItem, cartProvider);
                    },
                  ),
                ),
                // Order Summary
                _buildOrderSummary(context, cartProvider),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors. grey100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors. grey400,
            ),
          ),
          const SizedBox(height:  AppConstants.spacingLg),
          Text(
            'Keranjang Kosong',
            style: AppTypography.heading6. copyWith(color: AppColors. grey700),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk, pilih menu favoritmu! ',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppConstants. spacingLg),
          CustomButton(
            text: 'Mulai Pesan',
            onPressed: () => Navigator.pop(context),
            isFullWidth: false,
            type: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem cartItem, CartProvider cartProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants. paddingCard),
      decoration: BoxDecoration(
        color:  AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300. withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width:  70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: cartItem.menuItem.imageUrl. isNotEmpty
                  ? Image.network(
                      cartItem.menuItem.imageUrl,
                      fit: BoxFit. cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: AppColors.grey400),
                    )
                  : const Icon(Icons.restaurant, color: AppColors.grey400),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child:  Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.menuItem. name,
                  style: AppTypography.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  Helpers.formatCurrency(cartItem.menuItem. price),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 8),
                // Quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuantityButton(
                            icon: Icons.remove,
                            onTap: () => cartProvider.decrementQuantity(cartItem. menuItem.id),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${cartItem.quantity}',
                              style: AppTypography. labelMedium,
                            ),
                          ),
                          _buildQuantityButton(
                            icon: Icons. add,
                            onTap: () => cartProvider.incrementQuantity(cartItem.menuItem. id),
                          ),
                        ],
                      ),
                    ),
                    // Item total
                    Text(
                      Helpers.formatCurrency(cartItem.totalPrice),
                      style: AppTypography.labelLarge.copyWith(color: AppColors.primary900),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: AppColors.primary900),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingScreen),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color:  AppColors.grey300.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Summary rows
            _buildSummaryRow('Subtotal', Helpers.formatCurrency(cartProvider.subtotal)),
            const SizedBox(height: 8),
            _buildSummaryRow('Biaya Layanan (5%)', Helpers.formatCurrency(cartProvider.serviceFee)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            _buildSummaryRow(
              'Total',
              Helpers.formatCurrency(cartProvider.totalAmount),
              isTotal: true,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            // Checkout button
            CustomButton(
              text: 'Lanjut ke Pembayaran',
              onPressed:  () => Navigator.pushNamed(context, '/checkout'),
              type: ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? AppTypography.labelLarge :  AppTypography.bodyMedium,
        ),
        Text(
          value,
          style:  isTotal
              ? AppTypography.heading6.copyWith(color: AppColors.primary900)
              : AppTypography.labelMedium,
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder:  (context) => AlertDialog(
        title: const Text('Hapus Keranjang? '),
        content: const Text('Semua item akan dihapus dari keranjang. '),
        actions: [
          TextButton(
            onPressed:  () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed:  () {
              cartProvider.clearCart();
              Navigator.pop(context);
            },
            child: Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}