import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Penjual'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              color: AppColors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary900,
                    child: Text(
                      user?.name. isNotEmpty == true ? user!.name[0].toUpperCase() : 'S',
                      style: AppTypography.heading2.copyWith(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'Penjual', style: AppTypography.heading5),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary500. withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.store, size: 16, color:  AppColors.secondary500),
                        const SizedBox(width: 4),
                        Text(
                          'Penjual',
                          style:  AppTypography.labelSmall.copyWith(color: AppColors.secondary500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height:  8),
            // Menu Items
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.store_outlined,
                    title: 'Pengaturan Toko',
                    subtitle: 'Atur nama, deskripsi, dan jam operasional',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon:  Icons.restaurant_menu_outlined,
                    title:  'Kelola Menu',
                    subtitle:  'Tambah, edit, atau hapus menu',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.bar_chart_outlined,
                    title: 'Laporan Penjualan',
                    subtitle: 'Lihat statistik dan laporan',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title:  'Notifikasi',
                    subtitle: 'Atur preferensi notifikasi',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Account Settings
            Container(
              color:  AppColors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons. person_outline,
                    title:  'Edit Profil',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title:  'Ubah Password',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title:  'Bantuan',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Logout
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              color: AppColors.white,
              child: CustomButton(
                text: 'Keluar',
                onPressed: () => _showLogoutDialog(context, authProvider),
                type: ButtonType.outline,
                textColor: AppColors.error,
                backgroundColor: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            // App Version
            Text(
              'FILeats v1.0.0 (Seller)',
              style: AppTypography.caption.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors. grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary900, size: 22),
      ),
      title: Text(title, style: AppTypography.labelMedium),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTypography.caption.copyWith(color: AppColors.grey500),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey400),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator. pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: Text('Keluar', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}