import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/../core/constants/app_colors.dart';
import '/../core/constants/app_typography.dart';
import '/../core/constants/app_constants.dart';
import '/../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (! mounted) return;

    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.isAuthenticated) {
      final user = authProvider.currentUser! ;
      if (user.isBuyer) {
        Navigator. pushReplacementNamed(context, '/buyer-main');
      } else {
        Navigator.pushReplacementNamed(context, '/seller-main');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accent400,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 60,
                color: AppColors.primary900,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            // App Name
            Text(
              AppConstants.appName,
              style: AppTypography.heading2.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: AppConstants.spacingXs),
            // Tagline
            Text(
              AppConstants.tagline,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey300),
            ),
            const SizedBox(height: AppConstants. spacing2xl),
            // Loading
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors. accent400),
            ),
          ],
        ),
      ),
    );
  }
}