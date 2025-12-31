import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'seller_home_screen.dart';

// ==========================================
// 1. LOGIN PEMBELI (FIREBASE AUTH)
// ==========================================
class LoginScreenBuyer extends StatefulWidget {
  static const routeName = '/LoginScreenBuyer';

  @override
  State<LoginScreenBuyer> createState() => _LoginScreenBuyerState();
}

class _LoginScreenBuyerState extends State<LoginScreenBuyer> {
  // Controller & Logic
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleBuyerLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .loginBuyer(email, password);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI TETAP ORIGINAL (Tidak diubah styling-nya)
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          leading: IconButton(
            icon: Image.asset("assets/images/assets/back_button.png",
                width: 30, height: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFFF2A02D),
          flexibleSpace: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 35.0, top: 135.0),
              child: Text("Login",
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF2A02D),
        child: Center(
          child: SingleChildScrollView(
            // Agar aman saat keyboard muncul
            child: Container(
              // Margin sedikit agar tidak mepet layar
              margin: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 45.0), // Padding bawah tambahan
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 15),
                      child: Text(
                        "Masuk ke akun Anda",
                        style: TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Masuk sebagai pembeli",
                        style: TextStyle(
                          fontFamily: "Gabarito",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController, // Pasang Controller
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _passwordController, // Pasang Controller
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility_off),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style:
                              TextStyle(color: Color(0xFFF05F12), fontSize: 11),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed:
                                  _handleBuyerLogin, // Panggil fungsi Login
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF002647),
                                minimumSize: Size(343, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Atau lanjut dengan",
                        style: TextStyle(
                          color: Color(0xFFF05F12),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.apple, size: 30),
                        ),
                        SizedBox(width: 40),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook,
                              color: Colors.blue, size: 30),
                        ),
                        SizedBox(width: 40),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                              "assets/images/assets/Google_logo.png",
                              width: 30,
                              height: 30),
                        ),
                      ],
                    ),
                    SizedBox(height: 115),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: TextStyle(color: Colors.black, fontSize: 11),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Color(0xFFF05F12),
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFF05F12),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    SignupScreen.routeName,
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. LOGIN PENJUAL (HARDCODED) - DESAIN ORIGINAL
// ==========================================
class LoginScreenSeller extends StatefulWidget {
  static const routeName = '/LoginScreenSeller';

  @override
  State<LoginScreenSeller> createState() => _LoginScreenSellerState();
}

class _LoginScreenSellerState extends State<LoginScreenSeller> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleSellerLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    // Logic Hardcode dari Provider
    final tenantName = Provider.of<AuthProvider>(context, listen: false)
        .loginSellerManual(email, password);

    if (tenantName != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SellerHomeScreen(tenantName: tenantName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email/Password Salah! (Coba: admin)")),
      );
    }
  }

  // FUNGSI RAHASIA: Klik "Forgot Password" untuk buat akun toko di Firebase (Dev Only)
  void _seedSellerAccount() async {
    try {
      // Panggil fungsi seed (pastikan fungsi ini ada di auth_provider atau hapus baris ini jika pakai hardcode murni)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Mode Hardcode: Gunakan elly@fileats.com / admin")));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          leading: IconButton(
            icon: Image.asset("assets/images/assets/back_button.png",
                width: 30, height: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color(0xFFF2A02D),
          flexibleSpace: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 135.0),
              child: Text("Login",
                  style: TextStyle(
                    fontFamily: 'Gabarito',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF2A02D),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 15),
                      child: Text(
                        "Masuk ke akun Anda",
                        style: TextStyle(
                          fontFamily: 'Gabarito',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Masuk sebagai penjual",
                        style: TextStyle(
                          fontFamily: "Gabarito",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController, // Controller
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _passwordController, // Controller
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility_off),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        // RAHASIA: Klik ini untuk info login dev
                        onPressed: _seedSellerAccount,
                        child: Text(
                          "Forgot Password?",
                          style:
                              TextStyle(color: Color(0xFFF05F12), fontSize: 11),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _handleSellerLogin, // Fungsi Login Hardcode
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF002647),
                          minimumSize: Size(343, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Atau lanjut dengan",
                        style: TextStyle(
                          color: Color(0xFFF05F12),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Social Icons (Pajangan Saja untuk Penjual)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.apple, size: 30)),
                        SizedBox(width: 40),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.facebook,
                                color: Colors.blue, size: 30)),
                        SizedBox(width: 40),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                                "assets/images/assets/Google_logo.png",
                                width: 30,
                                height: 30)),
                      ],
                    ),
                    SizedBox(height: 115),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: TextStyle(color: Colors.black, fontSize: 11),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Color(0xFFF05F12),
                                fontSize: 11,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFF05F12),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Hubungi Developer untuk daftar jadi Mitra!")));
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
