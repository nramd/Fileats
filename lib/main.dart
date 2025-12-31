import 'package:fileats/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:fileats/screens/home_screen.dart';
import 'package:fileats/screens/login_screen.dart';
import 'package:fileats/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/feed_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()), // ADD HERE
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
        },
      ),
    ),
  );
}

class FileatSplashh extends StatelessWidget {
  static const routeName = '/splash';
  @override
  Widget build(BuildContext context) {
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
