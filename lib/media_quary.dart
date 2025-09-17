import 'package:flutter/material.dart';

void main() {
  runApp(MediaQuarryyy());
}

class MediaQuarryyy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomPageMQuary(),
    );
  }
}

class HomPageMQuary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar myAppbar() {
      return AppBar(
        title: Text("Media Query"),
      );
    }

    final mediaQueryHigh = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHigh -
        myAppbar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final bool isLanscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: myAppbar(),
      body: Center(
        child: (isLanscape)
            ? Column(
                children: [
                  Container(
                    height: bodyHeight * 0.4,
                    width: mediaQueryWidth,
                    color: Colors.amber,
                  ),
                  Container(
                    height: bodyHeight * 0.6,
                    color: Colors.white,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.red,
                          margin: EdgeInsets.all(10),
                          child: Text("Halo Semua"),
                        );
                      },
                    ),
                  )
                ],
              )
            : Column(
                children: [
                  Container(
                    height: bodyHeight * 0.3,
                    width: mediaQueryWidth,
                    color: Colors.amber,
                  ),
                  Container(
                    height: bodyHeight * 0.7,
                    color: Colors.red,
                    child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(),
                          title: Text("Halo Semua"),
                        );
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
