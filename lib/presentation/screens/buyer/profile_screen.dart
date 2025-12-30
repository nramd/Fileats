import 'package:flutter/material.dart';
import 'package:fileats/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage1(),
    );
  }
}

class ProfilePage1 extends StatefulWidget {
  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 40),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.account_circle_outlined,
                    size: 52, color: Colors.black),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User2137123',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gabarito",
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'User2137123@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Gabarito",
                      fontSize: 14,
                      color: Color(0xff757575),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '+62 812 3456 7890',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: "Gabarito",
                      fontSize: 14,
                      color: Color(0xff757575),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 115,
              ),
              InkWell(
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset("images/assets/rightArrow.png"),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 35, top: 30),
              title: Text(
                "Riwayat Pemesanan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.history_toggle_off_rounded,
                size: 36,
              ),
              onTap: () {
                return;
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 35, top: 20),
              title: Text(
                "Favorit",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.favorite,
                size: 36,
              ),
              onTap: () {
                return;
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 35, top: 20),
              title: Text(
                "Bantuan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.help,
                size: 36,
              ),
              onTap: () {
                return;
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 35, top: 20),
              title: Text(
                "Pengaturan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(
                Icons.settings,
                size: 36,
              ),
              onTap: () {
                return;
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 35, top: 20),
              title: Text(
                "Log Out",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.red),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.red,
                size: 36,
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FileatSplashh()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
