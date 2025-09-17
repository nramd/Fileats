import 'package:flutter/material.dart';

void main() {
  runApp(LayoutBuilderr());
}

class LayoutBuilderr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomPageLayooutB(),
    );
  }
}

class HomPageLayooutB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myAppbar = AppBar(
      title: Text("Layout Builder"),
    );
    final widthApp = MediaQuery.of(context).size.width;
    final heightApp = MediaQuery.of(context).size.height;
    final paddingTop = MediaQuery.of(context).padding.top;

    final bodyHeight = heightApp - myAppbar.preferredSize.height - paddingTop;
    return Scaffold(
      appBar: myAppbar,
      body: Container(
        width: widthApp,
        height: bodyHeight * 0.5,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyContainer(widthApp),
            MyContainer(widthApp),
            MyContainer(widthApp),
          ],
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  final double widthApp;
  const MyContainer(this.widthApp);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: widthApp * 0.2,
          height: constraints.maxHeight * 0.7,
          color: Colors.amber,
        );
      },
    );
  }
}
