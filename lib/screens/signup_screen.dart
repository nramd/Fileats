import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// UBAH KE STATEFULWIDGET AGAR BISA ADA FUNGSINYA
class SignupScreen extends StatefulWidget {
  static const routeName = '/sign-page-fileat';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. Controller untuk menangkap teks input
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Status loading

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 2. Fungsi Logika Daftar
  void _handleSignUp() async {
    // Ambil text dari controller
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();

    // Validasi sederhana
    if (email.isEmpty || password.isEmpty || firstName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mohon lengkapi semua data!")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Panggil Provider untuk daftar ke Firebase
      await Provider.of<AuthProvider>(context, listen: false)
          .signUpBuyer(email, password);

      // Jika berhasil
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Akun berhasil dibuat! Silakan Login.")));
      Navigator.pop(context); // Kembali ke login
    } catch (e) {
      // Jika gagal
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // DESAIN DI BAWAH INI SAMA PERSIS DENGAN KODE ANDA
    // HANYA DITAMBAHKAN 'controller' DAN 'onPressed'
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
              padding: const EdgeInsets.only(left: 15.0, top: 135.0),
              child: Text("Daftar",
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, bottom: 10),
                  child: Text(
                    "Buat Akun",
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
                    "Daftar sebagai pembeli",
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
                    controller: _firstNameController, // <-- Fungsi: Controller
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nama Awal",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _lastNameController, // <-- Fungsi: Controller
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Nama Akhir",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _emailController, // <-- Fungsi: Controller
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _passwordController, // <-- Fungsi: Controller
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
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _handleSignUp, // <-- Fungsi: Panggil Logic
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF002647),
                      minimumSize: Size(343, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white) // Loading kecil saat proses
                        : Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Atau lanjut dengan",
                    style: TextStyle(
                      color: Color(0xFFF05F12),
                      fontSize: 11,
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
                      icon: Icon(Icons.facebook, color: Colors.blue, size: 30),
                    ),
                    SizedBox(width: 40),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset("assets/images/assets/Google_logo.png",
                          width: 30, height: 30),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Sudah punya akun? ",
                      style: TextStyle(color: Colors.black, fontSize: 11),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Color(0xFFF05F12),
                            fontSize: 11,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFF05F12),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                // Tambahan padding bawah sedikit agar aman di HP berponi
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
