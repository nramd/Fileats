import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/community_provider.dart';
import 'providers/tenant_provider.dart';

// Screens
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/buyer/buyer_main_screen.dart';
import 'presentation/screens/buyer/tenant_detail_screen.dart';
import 'presentation/screens/buyer/cart_screen.dart';
import 'presentation/screens/buyer/checkout_screen.dart';
import 'presentation/screens/buyer/order_tracking_screen.dart';
import 'presentation/screens/seller/seller_main_screen.dart';

void main() async {
  WidgetsFlutterBinding. ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors. transparent,
      statusBarIconBrightness: Brightness. dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:  [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/buyer-main': (context) => const BuyerMainScreen(),
          '/tenant-detail': (context) => const TenantDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order-tracking': (context) => const OrderTrackingScreen(),
          '/seller-main': (context) => const SellerMainScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle routes with arguments
          switch (settings.name) {
            case '/order-tracking':
              final orderId = settings.arguments as String? ;
              return MaterialPageRoute(
                builder: (context) => OrderTrackingScreen(orderId: orderId),
              );
            default:
              return null;
          }
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          );
        },
      ),
    );
  }
}