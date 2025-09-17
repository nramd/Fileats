import 'package:flutter/material.dart';

void main() {
  runApp(MappingListt());
}

class MappingListt extends StatelessWidget {
  final List<Map<String, dynamic>> myList = [
    {
      "Name": "Messi",
      "Age": 35,
      "favColor": [
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
      ],
    },
    {
      "Name": "Ronaldo",
      "Age": 37,
      "favColor": ["white", "Blue", "Green"],
    },
    {
      "Name": "Messi",
      "Age": 35,
      "favColor": [
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
      ],
    },
    {
      "Name": "Ronaldo",
      "Age": 37,
      "favColor": ["white", "Blue", "Green"],
    },
    {
      "Name": "Messi",
      "Age": 35,
      "favColor": [
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
        "Black",
        "Red",
        "Amber",
      ],
    },
    {
      "Name": "Ronaldo",
      "Age": 37,
      "favColor": ["white", "Blue", "Green"],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("ID Apps"),
          backgroundColor: Colors.lightBlue,
        ),
        body: ListView(
          children: myList.map((data) {
            List myfavcolor = data["favColor"];
            return Card(
                margin: EdgeInsets.all(20),
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Name: ${data['Name']}"),
                              Text("Age: ${data['Age']}"),
                            ],
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: myfavcolor.map((color) {
                            return Container(
                              color: Colors.amberAccent,
                              margin: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 8,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(color),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        ),
      ),
    );
  }
}