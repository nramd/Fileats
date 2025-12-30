import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = AppConstants.roleBuyer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!. validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole,
    );

    if (!mounted) return;

    if (success) {
      if (_selectedRole == AppConstants.roleBuyer) {
        Navigator. pushReplacementNamed(context, '/buyer-main');
      } else {
        Navigator.pushReplacementNamed(context, '/seller-main');
      }
    } else {
      Helpers.showSnackBar(
        context,
        authProvider. errorMessage ?? 'Registrasi gagal',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: AppColors.primary900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  const EdgeInsets.all(AppConstants.paddingScreen),
          child: Form(
            key:  _formKey,
            child:  Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text('Buat Akun Baru', style: AppTypography.heading4),
                const SizedBox(height: AppConstants. spacingXs),
                Text(
                  'Daftar untuk mulai memesan makanan',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: AppConstants. spacingXl),
                // Role Selection
                Text('Daftar sebagai', style: AppTypography.labelMedium),
                const SizedBox(height: AppConstants. spacingSm),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleOption(
                        title: 'Pembeli',
                        subtitle: 'Pesan makanan',
                        icon: Icons.shopping_bag_outlined,
                        value: AppConstants.roleBuyer,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: _buildRoleOption(
                        title:  'Penjual',
                        subtitle: 'Kelola toko',
                        icon: Icons.store_outlined,
                        value: AppConstants.roleSeller,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants. spacingLg),
                // Name
                CustomTextField(
                  label:  'Nama Lengkap',
                  hint: 'Masukkan nama Anda',
                  controller: _nameController,
                  prefixIcon: Icons.person_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height:  AppConstants.spacingMd),
                // Email
                CustomTextField(
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon:  Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                // Password
                CustomTextField(
                  label: 'Password',
                  hint: 'Minimal 6 karakter',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingXl),
                // Register Button
                Consumer<AuthProvider>(
                  builder: (context, auth, child) {
                    return CustomButton(
                      text: 'Daftar',
                      onPressed: _handleRegister,
                      isLoading: auth.isLoading,
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment. center,
                  children: [
                    Text('Sudah punya akun?  ', style: AppTypography.bodyMedium),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child:  Text(
                        'Masuk',
                        style: AppTypography.labelMedium. copyWith(
                          color:  AppColors.secondary500,
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

  Widget _buildRoleOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _selectedRole == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: Container(
        padding: const EdgeInsets. all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isSelected ?  AppColors.primary900 : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary900 : AppColors.grey300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ?  AppColors.white : AppColors. grey600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTypography.labelMedium. copyWith(
                color: isSelected ? AppColors.white : AppColors.grey800,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppColors.grey300 : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}