import 'package:flutter/material.dart';

void main() {
  runApp(ImageWidgett());
}

class ImageWidgett extends StatelessWidget {
  const ImageWidgett({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Image Widget"),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 500,
            color: Colors.amber,
            child: Image.asset("images/fileat_logo.png", fit: BoxFit.cover,),
            // child: Image(
            //   image: AssetImage("images/fileat_logo.png"),
            //   fit: BoxFit.cover,
            // image: NetworkImage(url),
            // ),
          ),
        ),
      ),
    );
  }
}