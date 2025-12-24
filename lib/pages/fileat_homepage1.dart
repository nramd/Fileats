import 'package:flutter/material.dart';
import 'package:fileats/pages/fileat_communitypage1.dart';
import 'package:fileats/pages/fileat_profile1.dart';

class FileatHomePage1 extends StatefulWidget {
  static const routeName = '/fileat-homepage1';
  @override
  FileatHomePage1State createState() => FileatHomePage1State();
}

class FileatHomePage1State extends State<FileatHomePage1> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FileatHomePage1Body(),
    CommunityPage1(),
    Center(child: Text("Orders Page")),
    ProfilePage1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Image.asset("images/assets/FILeats.png"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Apa yang ingin kamu",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Gabarito",
                          ),
                        ),
                        Text(
                          "makan hari ini?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Gabarito",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffEC831E),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? "images/navbar/s_Home.png"
                  : "images/navbar/Home.png",
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? "images/navbar/s_Community.png"
                  : "images/navbar/Community.png",
              width: 24,
              height: 24,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? "images/navbar/s_orders.png"
                  : "images/navbar/orders.png",
              width: 24,
              height: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 3
                  ? "images/navbar/s_Profile.png"
                  : "images/navbar/Profile.png",
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xff002240),
        unselectedItemColor: Color(0xffffffff),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            TextStyle(fontFamily: "Gabarito", fontWeight: FontWeight.w100),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class FileatHomePage1Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Color(0xffD2D2D2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari disini...",
                        hintStyle: TextStyle(fontFamily: "Gabarito"),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Category Chips (Minuman, Nasi, dll.)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategoryCard("Minuman",
                      "images/homepage_menumakan/fileat_minuman.png"),
                  _buildCategoryCard(
                      "Nasi", "images/homepage_menumakan/fileat_nasi.png"),
                  _buildCategoryCard(
                      "Mie", "images/homepage_menumakan/fileat_mie.png"),
                  _buildCategoryCard(
                      "Kue", "images/homepage_menumakan/fileat_kue.png"),
                  _buildCategoryCard(
                      "Snack", "images/homepage_menumakan/fileat_snack.png"),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Daftar restoran atau menu
            Expanded(
              child: ListView(
                // Scroll ke bawah untuk menampilkan toko
                children: [
                  _buildRestaurantTile(
                    "Lalapan Mbak Elly",
                    [
                      {
                        'name': 'Nasi Usus',
                        'price': 12000,
                        'image': 'images/menumakan_toko/n_usus.jpg'
                      },
                      {
                        'name': 'Nasi Ayam Crispy',
                        'price': 13000,
                        'image': 'images/menumakan_toko/n_a_Crispy.jpg'
                      },
                      {
                        'name': 'Nasi Ayam Ungkep',
                        'price': 13000,
                        'image': 'images/menumakan_toko/n_a_ungkep.jpg'
                      },
                      {
                        'name': 'Nasi Ayam Bakar',
                        'price': 15000,
                        'image': 'images/menumakan_toko/n_a_Bakar.jpg'
                      },
                      {
                        'name': 'Nasi Ayam Kulit',
                        'price': 11000,
                        'image': 'images/menumakan_toko/n_KulitAyam.jpg'
                      },
                    ],
                  ),
                  _buildRestaurantTile(
                    "Warung Bangdor",
                    [
                      {
                        'name': 'Nasi Goreng',
                        'price': 12000,
                        'image': 'images/menumakan_toko/n_goreng.jpg'
                      },
                      {
                        'name': 'Nasi Gila',
                        'price': 13000,
                        'image': 'images/menumakan_toko/n_gila.jpg'
                      },
                      {
                        'name': 'Mie Ayam',
                        'price': 15000,
                        'image': 'images/menumakan_toko/mie_ayam.jpg'
                      },
                      {
                        'name': 'Nasi Kuning',
                        'price': 11000,
                        'image': 'images/menumakan_toko/n_kuning.jpg'
                      },
                      {
                        'name': 'Nasi Padang',
                        'price': 14000,
                        'image': 'images/menumakan_toko/n_padang.jpg'
                      },
                    ],
                  ),
                  _buildRestaurantTile(
                    "Warung Bu Indah", // Khusus menjual mie
                    [
                      {
                        'name': 'Indomie Goreng',
                        'price': 7000,
                        'image': 'images/menumakan_toko/indomie_g.jpg'
                      },
                      {
                        'name': 'Indomie Kuah',
                        'price': 7000,
                        'image': 'images/menumakan_toko/indomie_k.jpg'
                      },
                      {
                        'name': 'Indomie Double',
                        'price': 12000,
                        'image': 'images/menumakan_toko/indomie_g.jpg'
                      },
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () {
            // Aksi ketika kategori dipilih
          },
          child: Container(
            width: 90, // Lebar card
            height: 90, // Tinggi card termasuk teks
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: 50, // Ukuran gambar
                  height: 50,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: "Gabarito",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantTile(String name, List<Map<String, dynamic>> menus) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: "Gabarito"),
          ),
          // SingleChildScrollView untuk scroll horizontal pada menu restoran
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Scroll ke kanan untuk menu
            child: Row(
              children: menus.map((menu) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildMenuTile(
                      menu['name'], menu['price'], menu['image']),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String menu, int price, String imagePath) {
    return SizedBox(
      width: 160,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu,
                      style: TextStyle(color: Colors.white, fontSize: 11.0),
                    ),
                    Text(
                      "Rp. $price",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
