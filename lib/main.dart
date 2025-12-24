import 'package:flutter/material.dart';
import 'package:fileats/pages/fileat_homepage1.dart';
import 'package:fileats/pages/fileat_login_page.dart';
import 'package:fileats/pages/fileat_sign_up.dart';
import 'package:provider/provider.dart';
import 'pages/fileat_feed_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FeedModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FileatSplashh(),
        routes: {
          LoginPagePembeli.routeName: (context) => LoginPagePembeli(),
          LoginPagePenjual.routeName: (context) => LoginPagePenjual(),
          SignPageFileat.routeName: (context) => SignPageFileat(),
          FileatHomePage1.routeName: (context) => FileatHomePage1(),
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
            Image.asset("images/assets/role.png"),
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
                    LoginPagePenjual.routeName,
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
                    LoginPagePembeli.routeName,
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
