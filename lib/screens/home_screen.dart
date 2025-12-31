import 'package:fileats/providers/cart_provider.dart';
import 'package:fileats/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:fileats/screens/community_screen.dart';
import 'package:fileats/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import 'menu_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/fileat-homepage1';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreenBody(),
    CommunityScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Image.asset("assets/images/assets/FILeats.png"),
              actions: [
                Consumer<CartProvider>(
                  builder: (_, cart, ch) => Stack(
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.shopping_cart, color: Color(0xffEC831E)),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${cart.itemCount}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
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
                  ? "assets/images/navbar/s_Home.png"
                  : "assets/images/navbar/Home.png",
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? "assets/images/navbar/s_Community.png"
                  : "assets/images/navbar/Community.png",
              width: 24,
              height: 24,
            ),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? "assets/images/navbar/s_orders.png"
                  : "assets/images/navbar/orders.png",
              width: 24,
              height: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 3
                  ? "assets/images/navbar/s_Profile.png"
                  : "assets/images/navbar/Profile.png",
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

class HomeScreenBody extends StatefulWidget {
  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  final List<Map<String, dynamic>> _allMenus = [
    // --- LALAPAN MBAK ELLY (Spesialis Ayam & Usus) ---
    {
      'tenant': "Lalapan Mbak Elly",
      'name': 'Nasi Ayam Bakar',
      'price': 15000,
      'category': 'Ayam',
      'image': 'assets/images/menumakan_toko/n_a_Bakar.jpg'
    },
    {
      'tenant': "Lalapan Mbak Elly",
      'name': 'Nasi Ayam Crispy',
      'price': 13000,
      'category': 'Ayam',
      'image': 'assets/images/menumakan_toko/n_a_Crispy.jpg'
    },
    {
      'tenant': "Lalapan Mbak Elly",
      'name': 'Nasi Ayam Ungkep',
      'price': 13000,
      'category': 'Ayam',
      'image': 'assets/images/menumakan_toko/n_a_ungkep.jpg'
    },
    {
      'tenant': "Lalapan Mbak Elly",
      'name': 'Nasi Usus',
      'price': 10000,
      'category': 'Nasi',
      'image': 'assets/images/menumakan_toko/n_usus.jpg'
    },

    // --- WARUNG BANGDOR (Spesialis Gorengan & Mie Ayam) ---
    {
      'tenant': "Warung Bangdor",
      'name': 'Nasi Goreng',
      'price': 12000,
      'category': 'Nasi',
      'image': 'assets/images/menumakan_toko/n_goreng.jpg'
    },
    {
      'tenant': "Warung Bangdor",
      'name': 'Nasi Gila',
      'price': 14000,
      'category': 'Nasi',
      'image': 'assets/images/menumakan_toko/n_gila.jpg'
    },
    {
      'tenant': "Warung Bangdor",
      'name': 'Nasi Kulit Ayam',
      'price': 15000,
      'category': 'Ayam',
      'image': 'assets/images/menumakan_toko/n_KulitAyam.jpg'
    },
    {
      'tenant': "Warung Bangdor",
      'name': 'Mie Ayam',
      'price': 12000,
      'category': 'Mie',
      'image': 'assets/images/menumakan_toko/mie_ayam.jpg'
    },

    // --- WARUNG BU INDAH (Aneka Nasi & Indomie) ---
    {
      'tenant': "Warung Bu Indah",
      'name': 'Nasi Kuning',
      'price': 10000,
      'category': 'Nasi',
      'image': 'assets/images/menumakan_toko/n_kuning.jpg'
    },
    {
      'tenant': "Warung Bu Indah",
      'name': 'Nasi Padang',
      'price': 18000,
      'category': 'Nasi',
      'image': 'assets/images/menumakan_toko/n_padang.jpg'
    },
    {
      'tenant': "Warung Bu Indah",
      'name': 'Indomie Goreng',
      'price': 7000,
      'category': 'Mie',
      'image': 'assets/images/menumakan_toko/indomie_g.jpg'
    },
    {
      'tenant': "Warung Bu Indah",
      'name': 'Indomie Kuah',
      'price': 7000,
      'category': 'Mie',
      'image': 'assets/images/menumakan_toko/indomie_k.jpg'
    },
  ];

  // Variabel untuk Search & Filter
  String _searchQuery = "";
  String _selectedCategory = "Semua";
  List<Map<String, dynamic>> _filteredMenus = [];

  @override
  void initState() {
    super.initState();
    _filteredMenus = _allMenus; // Awalnya tampilkan semua
  }

  // LOGIC FILTERING
  void _runFilter() {
    setState(() {
      _filteredMenus = _allMenus.where((menu) {
        // Filter Text Search
        final nameMatch = menu['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
        final tenantMatch = menu['tenant']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());

        // Filter Category
        final categoryMatch = _selectedCategory == "Semua" ||
            menu['category'] == _selectedCategory;

        return (nameMatch || tenantMatch) && categoryMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- SEARCH BAR (SUDAH AKTIF) ---
            TextField(
              onChanged: (value) {
                _searchQuery = value;
                _runFilter(); // Jalankan filter tiap ketik
              },
              decoration: InputDecoration(
                hintText: "Mau makan apa hari ini?",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),

            // --- CATEGORY CHIPS (SUDAH AKTIF) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip("Semua"),
                  _buildCategoryChip("Nasi"),
                  _buildCategoryChip("Ayam"),
                  _buildCategoryChip("Mie"),
                  _buildCategoryChip("Minuman"),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // --- HASIL PENCARIAN ---
            Expanded(
              child: _filteredMenus.isEmpty
                  ? Center(
                      child: Text("Menu tidak ditemukan",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _filteredMenus.length,
                      itemBuilder: (context, index) {
                        final menu = _filteredMenus[index];
                        // Tampilkan per Item
                        return _buildSingleMenuRow(menu);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Kategori
  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Color(0xffED831F),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (bool selected) {
          setState(() {
            _selectedCategory = label;
            _runFilter();
          });
        },
      ),
    );
  }

  // Widget Tampilan Menu (Updated dengan Navigasi Detail)
  Widget _buildSingleMenuRow(Map<String, dynamic> menu) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        // 1. BUNGKUS DENGAN INKWELL AGAR BISA DIKLIK
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // 2. NAVIGASI KE HALAMAN DETAIL SAAT DIKLIK
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenuDetailScreen(menu: menu),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Gambar Menu
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  menu['image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      Container(width: 80, height: 80, color: Colors.grey),
                ),
              ),
              SizedBox(width: 15),
              // Info Menu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(menu['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: "Gabarito")),
                    Text(menu['tenant'],
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 5),
                    Text("Rp ${menu['price']}",
                        style: TextStyle(
                            color: Color(0xffED831F),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              // Tombol Tambah Cepat (Quick Add)
              InkWell(
                onTap: () {
                  // Add to cart tanpa catatan (Quick Add)
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    menu['name'],
                    menu['name'],
                    menu['price'],
                    menu['tenant'],
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${menu['name']} ditambahkan!'),
                    duration: Duration(milliseconds: 800),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(0xffED831F), shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white, size: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
