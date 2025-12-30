class AppConstants {
  // App Info
  static const String appName = 'FILeats';
  static const String tagline = 'No Worry, No Antri, Just Feel It';
  
  // Spacing
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;
  static const double spacing3xl = 64.0;
  
  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;
  
  // Padding
  static const double paddingScreen = 16.0;
  static const double paddingCard = 16.0;
  
  // Animation Duration
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String tenantsCollection = 'tenants';
  static const String menuItemsCollection = 'menu_items';
  static const String ordersCollection = 'orders';
  static const String communityPostsCollection = 'community_posts';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderCompleted = 'completed';
  static const String orderCancelled = 'cancelled';
  
  // User Roles
  static const String roleBuyer = 'buyer';
  static const String roleSeller = 'seller';
}