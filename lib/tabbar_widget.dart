import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TabBarWidgett(),
  ));
}

class TabBarWidgett extends StatelessWidget {
  List <Tab> myTab = [
                Tab(icon: Icon(Icons.directions_car), text: "Car"),
                Tab(icon: Icon(Icons.directions_transit), text: "Transit"),
                Tab(icon: Icon(Icons.directions_bike), text: "Bike"),
              ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreen,
            title: Text('TabBar Example'),
            bottom: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.yellow,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal
              ),
              tabs: myTab,
              // indicatorColor: Colors.green,
              // indicatorWeight: 5,
              // indicatorPadding: EdgeInsets.all(5),
              indicator: BoxDecoration(
                color: Colors.black,
                // borderRadius: BorderRadius.circular(50),
                border: Border(
                  top: BorderSide(
                    color: Colors.red,
                    width: 5,
                  )
                )
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Content for Car Tab')),
              Center(child: Text('Content for Transit Tab')),
              Center(child: Text('Content for Bike Tab')),
            ],
          ),
        ),
      ),
    );
  }
}
