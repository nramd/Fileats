import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super. key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!. validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final user = authProvider.currentUser! ;
      if (user.isBuyer) {
        Navigator.pushReplacementNamed(context, '/buyer-main');
      } else {
        Navigator. pushReplacementNamed(context, '/seller-main');
      }
    } else {
      Helpers.showSnackBar(
        context,
        authProvider.errorMessage ??  'Login gagal',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingScreen),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacing2xl),
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:  AppColors.accent400,
                          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          size: 40,
                          color: AppColors.primary900,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(AppConstants.appName, style: AppTypography.heading4),
                      const SizedBox(height: AppConstants.spacingXs),
                      Text(
                        'Masuk ke akun Anda',
                        style: AppTypography.bodyMedium. copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacing2xl),
                // Email
                CustomTextField(
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  controller: _emailController,
                  keyboardType:  TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value. contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                // Password
                CustomTextField(
                  label: 'Password',
                  hint: 'Masukkan password Anda',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value. length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingLg),
                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return CustomButton(
                      text:  'Masuk',
                      onPressed: _handleLogin,
                      isLoading: auth.isLoading,
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                // Register Link
                Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?  ',
                      style: AppTypography.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Daftar',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.secondary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}