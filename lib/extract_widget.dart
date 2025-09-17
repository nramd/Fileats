import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExtractWidgett());
}

// ignore: must_be_immutable
class ExtractWidgett extends StatelessWidget {
  var faker = Faker();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Extract Widget"),
          backgroundColor: Colors.lightGreen,
        ),
        body: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return ChatItem(
              imageUrl: "https://picsum.photos/id/$index/200/300",
              title: faker.person.name(),
              subtitle: faker.lorem.sentence(),
              onTap: () {
                return;
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ChatItem(
      {required this.imageUrl,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text("10:00 PM"),
      ),
    );
  }
}
