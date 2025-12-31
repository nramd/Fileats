import 'package:fileats/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:fileats/screens/home_screen.dart';
import 'package:fileats/screens/login_screen.dart';
import 'package:fileats/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';
import 'providers/cart_provider.dart';
import 'package:fileats/screens/cart_screen.dart';
import 'providers/auth_provider.dart';

// TAMBAHAN: Import Firebase Auth untuk cek user
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FileatSplashh(),
        routes: {
          LoginScreenBuyer.routeName: (context) => LoginScreenBuyer(),
          LoginScreenSeller.routeName: (context) => LoginScreenSeller(),
          SignupScreen.routeName: (context) => SignupScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          FileatSplashh.routeName: (context) => FileatSplashh(),
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    ),
  );
}

// UBAH KE STATEFUL WIDGET AGAR BISA CEK LOGIN
class FileatSplashh extends StatefulWidget {
  static const routeName = '/splash';

  @override
  State<FileatSplashh> createState() => _FileatSplashhState();
}

class _FileatSplashhState extends State<FileatSplashh> {
  
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  // --- LOGIKA AUTO LOGIN ---
  void _checkAutoLogin() async {
    // 1. Tunggu 1 detik agar splash screen terlihat sebentar (Smooth effect)
    await Future.delayed(Duration(seconds: 1));

    // 2. Cek apakah ada user (Pembeli) yang nyangkut di Firebase
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // JIKA SUDAH LOGIN: Langsung pindah ke Home Screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    }
    // JIKA BELUM LOGIN: Diam saja, biarkan user melihat tombol pilihan Penjual/Pembeli
  }

  @override
  Widget build(BuildContext context) {
    // DESAIN DI BAWAH INI SAMA PERSIS DENGAN KODE ASLI ANDA
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 190),
            Image.asset("assets/images/assets/role.png"),
            SizedBox(height: 20),
            Text(
              "Gunakan Aplikasi",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Gabarito",
                fontSize: 25,
                color: Color(0xffED831F),
              ),
            ),
            Text(
              "Sebagai?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Gabarito",
                fontSize: 25,
                color: Color(0xffED831F),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    LoginScreenSeller.routeName,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF002647),
                  minimumSize: Size(343, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Penjual",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gabarito",
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    LoginScreenBuyer.routeName,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFFFFF),
                  minimumSize: Size(343, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color(0xff002647)),
                  ),
                ),
                child: Text(
                  "Pembeli",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff002647),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gabarito",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}