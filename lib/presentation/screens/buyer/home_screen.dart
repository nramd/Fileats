import 'package:fileats/presentation/widgets/common/tenant_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/tenant_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../widgets/buyer/tenant_card.dart';
import '../../widgets/common/custom_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super. key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TenantProvider>().fetchTenants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding:  const EdgeInsets.all(AppConstants.paddingScreen),
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:  CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, ${user?.name ?? 'User'}!  👋',
                            style: AppTypography.heading6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mau makan apa hari ini?',
                            style: AppTypography. bodyMedium. copyWith(
                              color:  AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                      // Cart Icon
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/cart'),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors. grey100,
                                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColors.primary900,
                              ),
                            ),
                            if (cartProvider.totalItems > 0)
                              Positioned(
                                right:  0,
                                top:  0,
                                child:  Container(
                                  padding:  const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${cartProvider.totalItems}',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.primary900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  // Search
                  CustomTextField(
                    hint: 'Cari makanan atau tenant.. .',
                    controller: _searchController,
                    prefixIcon: Icons.search,
                  ),
                ],
              ),
            ),
            // Tenant List
            Expanded(
              child: Consumer<TenantProvider>(
                builder: (context, tenantProvider, child) {
                  if (tenantProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (tenantProvider. tenants.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () => tenantProvider.fetchTenants(),
                    child: ListView(
                      padding: const EdgeInsets.all(AppConstants.paddingScreen),
                      children:  [
                        Text(
                          'Tenant Kantin FILKOM',
                          style: AppTypography.heading6,
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        ... tenantProvider.tenants.map((tenant) => TenantCard(
                          tenant: tenant,
                          onTap: () {
                            tenantProvider.selectTenant(tenant);
                            Navigator.pushNamed(context, '/tenant-detail');
                          },
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Belum ada tenant',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tenant kantin akan muncul di sini',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
}