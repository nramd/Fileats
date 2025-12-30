import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/tenant_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../widgets/common/menu_card.dart';

class TenantDetailScreen extends StatefulWidget {
  const TenantDetailScreen({super. key});

  @override
  State<TenantDetailScreen> createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final tenantProvider = context.watch<TenantProvider>();
    final cartProvider = context.watch<CartProvider>();
    final tenant = tenantProvider.selectedTenant;

    if (tenant == null) {
      return const Scaffold(body: Center(child: Text('Tenant tidak ditemukan')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary900,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background:  Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: tenant.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: AppColors.grey300),
                    errorWidget: (c, u, e) => Container(
                      color: AppColors.grey300,
                      child: const Icon(Icons.store, size: 60),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient:  LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.primary900.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom:  16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant.name,
                          style: AppTypography.heading5. copyWith(color: AppColors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: AppColors.accent400),
                            const SizedBox(width: 4),
                            Text(
                              '${tenant.rating} (${tenant.totalReviews})',
                              style:  AppTypography.labelMedium.copyWith(color: AppColors.white),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: tenant.isOpen ? AppColors.success : AppColors.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tenant.isOpen ? 'Buka' : 'Tutup',
                                style: AppTypography.caption.copyWith(color: AppColors.white),
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
          ),
          // Categories
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingScreen),
                children: tenantProvider.categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                      backgroundColor: AppColors.white,
                      selectedColor: AppColors.primary900,
                      labelStyle: AppTypography.labelMedium.copyWith(
                        color: isSelected ? AppColors.white : AppColors.grey700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Menu Items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingScreen),
            sliver: tenantProvider.isLoading
                ? const SliverToBoxAdapter(
                    child: Center(child:  CircularProgressIndicator()),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final menuItems = tenantProvider.getMenuByCategory(_selectedCategory);
                        if (index >= menuItems.length) return null;
                        final item = menuItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                          child: MenuCard(
                            menuItem: item,
                            quantity: cartProvider.getItemQuantity(item. id),
                            onAdd: () => cartProvider.addItem(item, tenant),
                            onRemove: () => cartProvider.decrementQuantity(item.id),
                          ),
                        );
                      },
                      childCount: tenantProvider.getMenuByCategory(_selectedCategory).length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      // Bottom Cart Bar
      bottomNavigationBar: cartProvider.isNotEmpty && cartProvider.currentTenant?. id == tenant.id
          ? Container(
              padding: const EdgeInsets.all(AppConstants.paddingScreen),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey300.withOpacity(0.5),
                    blurRadius:  10,
                    offset:  const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                  style:  ElevatedButton.styleFrom(
                    backgroundColor: AppColors. primary900,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                  ),
                  child:  Row(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${cartProvider.totalItems}',
                          style: AppTypography.labelMedium.copyWith(color: AppColors.primary900),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Lihat Keranjang', style:  AppTypography.buttonMedium),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}