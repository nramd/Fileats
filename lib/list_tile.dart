import 'package:flutter/material.dart';

void main() {
  runApp(ListTiile());
}

class ListTiile extends StatelessWidget {
  const ListTiile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("List Tile"),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text("This is Title"),
              subtitle: Text("This is Subtitle okay"),
              leading: CircleAvatar(),
              trailing: Text("10:00 PM"),
              // tileColor: Colors.amber,
              // dense: true,
              onTap: () {
                return;
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text("This is Title"),
              subtitle: Text("This is Subtitle okay"),
              leading: CircleAvatar(),
              trailing: Text("10:00 PM"),
              onTap: () {
                return;
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text("This is Title"),
              subtitle: Text("This is Subtitle okay"),
              leading: CircleAvatar(),
              trailing: Text("10:00 PM"),
              onTap: () {
                return;
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text("This is Title"),
              subtitle: Text("This is Subtitle okay"),
              leading: CircleAvatar(),
              trailing: Text("10:00 PM"),
              onTap: () {
                return;
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text("This is Title"),
              subtitle: Text("This is Subtitle okay"),
              leading: CircleAvatar(),
              trailing: Text("10:00 PM"),
              onTap: () {
                return;
              },
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}