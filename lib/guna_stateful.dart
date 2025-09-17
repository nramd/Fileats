import 'package:flutter/material.dart';

void main() {
  runApp(GunaStateful());
}

class GunaStateful extends StatefulWidget {
  @override
  State<GunaStateful> createState() => _GunaStatefulState();
}

class _GunaStatefulState extends State<GunaStateful> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Dynamic Apps"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 100, // Atur tinggi yang tetap
              child: Center(
                child: Text(
                  counter.toString(),
                  style: TextStyle(
                    fontSize: 40 + double.parse(counter.toString()),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (counter != 1) {
                      setState(() {
                        counter--;
                      });
                    }
                  },
                  child: Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      counter++;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
