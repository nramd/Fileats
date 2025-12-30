import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary900,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child:  Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              color: AppColors.white,
              child: Column(
                children:  [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary900,
                    child: Text(
                      user?.name. isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                      style: AppTypography.heading2.copyWith(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'User', style: AppTypography.heading5),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent400. withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                    ),
                    child: Text(
                      user?.isBuyer == true ? 'Pembeli' : 'Penjual',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.primary900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Menu Items
            Container(
              color: AppColors.white,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title:  'Edit Profil',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon:  Icons.lock_outline,
                    title: 'Ubah Password',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons. help_outline,
                    title:  'Bantuan',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title:  'Tentang Aplikasi',
                    onTap:  () => _showAboutDialog(context),
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
              'FILeats v1.0.0',
              style: AppTypography.caption.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height:  8),
            Text(
              AppConstants.tagline,
              style: AppTypography.caption.copyWith(color: AppColors.grey400),
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors. primary900),
      title: Text(title, style: AppTypography.bodyMedium),
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent400,
                borderRadius: BorderRadius. circular(8),
              ),
              child:  const Icon(Icons.restaurant_menu, color: AppColors. primary900),
            ),
            const SizedBox(width: 12),
            const Text('FILeats'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.tagline, style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'Aplikasi pemesanan makanan untuk kantin FILKOM Universitas Brawijaya.',
              style: AppTypography. bodySmall. copyWith(color: AppColors. grey600),
            ),
            const SizedBox(height: 16),
            Text('Tim Pengembang:', style: AppTypography.labelMedium),
            const SizedBox(height: 8),
            Text('• Arif Athaya Harahap', style: AppTypography.bodySmall),
            Text('• Nugrah Ramadhani', style: AppTypography.bodySmall),
            Text('• Ariiq Tsany Zu', style: AppTypography.bodySmall),
            Text('• Muhammad Faiz Fauzan', style: AppTypography.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}