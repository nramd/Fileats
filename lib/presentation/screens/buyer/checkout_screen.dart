import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';
import '../../widgets/common/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'qris';
  final _notesController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _processOrder() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final authProvider = context.read<AuthProvider>();
    final cartProvider = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final user = authProvider.currentUser;
    if (user == null) {
      Helpers.showSnackBar(context, 'Silakan login terlebih dahulu', isError: true);
      setState(() => _isProcessing = false);
      return;
    }

    final order = await orderProvider.createOrder(
      buyerId: user.uid,
      buyerName: user.name,
      cartProvider: cartProvider,
      paymentMethod: _selectedPayment,
      notes: _notesController. text. isNotEmpty ? _notesController. text : null,
    );

    if (! mounted) return;

    if (order != null) {
      cartProvider.clearCart();
      Navigator.pushReplacementNamed(
        context,
        '/order-tracking',
        arguments: order. id,
      );
    } else {
      Helpers.showSnackBar(
        context,
        orderProvider.errorMessage ??  'Gagal membuat pesanan',
        isError: true,
      );
    }

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context. watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            _buildSection(
              title: 'Ringkasan Pesanan',
              child: Column(
                children: [
                  // Tenant
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:  AppColors.accent400.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.store, color: AppColors.primary900, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        cartProvider.currentTenant?.name ??  '',
                        style: AppTypography.labelLarge,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  // Items
                  ... cartProvider.items.values.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: AppTypography.labelMedium. copyWith(color: AppColors. primary900),
                        ),
                        const SizedBox(width:  12),
                        Expanded(
                          child: Text(item.menuItem.name, style: AppTypography.bodyMedium),
                        ),
                        Text(
                          Helpers.formatCurrency(item. totalPrice),
                          style: AppTypography.labelMedium,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            // Estimation Time
            _buildSection(
              title: 'Estimasi Waktu',
              child: Row(
                children: [
                  Container(
                    padding:  const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: const Icon(Icons. access_time, color: AppColors. secondary500),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text('Dapat diambil dalam', style: AppTypography.bodySmall),
                      Text(
                        '${cartProvider. estimatedMinutes} Menit',
                        style:  AppTypography.heading6.copyWith(color: AppColors.secondary500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Payment Method
            _buildSection(
              title: 'Metode Pembayaran',
              child:  Column(
                children: [
                  _buildPaymentOption(
                    id: 'qris',
                    title: 'QRIS',
                    subtitle: 'Scan QR untuk bayar',
                    icon: Icons.qr_code,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                    id: 'ewallet',
                    title: 'E-Wallet',
                    subtitle: 'GoPay, OVO, Dana, dll',
                    icon:  Icons.account_balance_wallet,
                  ),
                  const SizedBox(height:  12),
                  _buildPaymentOption(
                    id: 'cash',
                    title: 'Tunai',
                    subtitle: 'Bayar saat mengambil',
                    icon:  Icons.money,
                  ),
                ],
              ),
            ),
            // Notes
            _buildSection(
              title: 'Catatan (Opsional)',
              child:  TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tambahkan catatan untuk penjual.. .',
                  hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey400),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius:  BorderRadius.circular(AppConstants. radiusMd),
                    borderSide: BorderSide. none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // Bottom Payment Summary
      bottomNavigationBar: _buildBottomBar(cartProvider),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets. only(top: 8),
      padding: const EdgeInsets.all(AppConstants.paddingScreen),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelLarge),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPayment == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = id),
      child: Container(
        padding: const EdgeInsets. all(16),
        decoration:  BoxDecoration(
          color:  isSelected ? AppColors.primary900. withOpacity(0.05) : AppColors.grey50,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary900 : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary900 : AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              child:  Icon(
                icon,
                color: isSelected ? AppColors.white : AppColors.grey600,
                size: 24,
              ),
            ),
            const SizedBox(width:  16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelMedium),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons. radio_button_checked : Icons.radio_button_off,
              color: isSelected ?  AppColors.primary900 : AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets. all(AppConstants.paddingScreen),
      decoration: BoxDecoration(
        color: AppColors. white,
        boxShadow: [
          BoxShadow(
            color: AppColors. grey300.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Pembayaran', style: AppTypography.bodyMedium),
                Text(
                  Helpers.formatCurrency(cartProvider.totalAmount),
                  style: AppTypography.heading6.copyWith(color: AppColors. primary900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Bayar Sekarang',
              onPressed: _processOrder,
              isLoading: _isProcessing,
              type: ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }
}