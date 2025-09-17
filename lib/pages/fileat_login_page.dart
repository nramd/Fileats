import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/fileat_sign_up.dart';
import 'package:flutter_application_1/pages/fileat_homepage1.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPagePembeli(),
//     ),
//   );
// }

class LoginPagePembeli extends StatelessWidget {
  static const routeName = '/loginpagepembeli';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          leading: IconButton(
            icon: Image.asset("images/assets/back_button.png",
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
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
                      style: TextStyle(color: Color(0xFFF05F12), fontSize: 11),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => FileatHomePage1()),
                        (Route<dynamic> route) => false,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.apple, size: 30),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.facebook, color: Colors.blue, size: 30),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset("images/assets/Google_logo.png",
                          width: 30, height: 30),
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
                                SignPageFileat.routeName,
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
    );
  }
}

class LoginPagePenjual extends StatelessWidget {
  static const routeName = '/loginpagepenjual';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: AppBar(
            leading: IconButton(
              icon: Image.asset("images/assets/back_button.png",
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
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
                    child: ElevatedButton(
                      onPressed: () {},
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.apple, size: 30),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon:
                            Icon(Icons.facebook, color: Colors.blue, size: 30),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset("images/assets/Google_logo.png",
                            width: 30, height: 30),
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
                                // Menggunakan Builder untuk mendapatkan context yang tepat
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => SignPageFileat()),
                                // );
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
      );
  }
}
