import 'package:flutter/material.dart';
// PERBAIKAN DI SINI: Tambahkan 'hide AuthProvider'
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; 
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; 
import '../main.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Ambil data User yang sedang login
    final User? user = FirebaseAuth.instance.currentUser;
    // Ambil nama dari email (sebelum @) sebagai placeholder nama
    final String displayName = user?.email?.split('@')[0] ?? "Pengguna";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 26,
                child: Icon(Icons.account_circle_outlined,
                    size: 52, color: Colors.black),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gabarito",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      user?.email ?? "Email tidak tersedia", 
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "Gabarito",
                        fontSize: 14,
                        color: Color(0xff757575),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      '+62 8xx xxxx xxxx',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: "Gabarito",
                        fontSize: 14,
                        color: Color(0xff757575),
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Image.asset("assets/images/assets/rightArrow.png", width: 24),
                onPressed: () {},
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
              contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              title: Text(
                "Riwayat Pemesanan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(Icons.history_toggle_off_rounded, size: 30),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              title: Text(
                "Favorit",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(Icons.favorite_border, size: 30),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              title: Text(
                "Bantuan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(Icons.help_outline, size: 30),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              title: Text(
                "Pengaturan",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              leading: Icon(Icons.settings_outlined, size: 30),
              onTap: () {},
            ),
            
            // --- TOMBOL LOGOUT ---
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              title: Text(
                "Log Out",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.red,
                size: 30,
              ),
              onTap: () async {
                // Panggil logout dari Provider Anda (bukan dari Firebase Auth langsung)
                await Provider.of<AuthProvider>(context, listen: false).logout();

                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => FileatSplashh()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}