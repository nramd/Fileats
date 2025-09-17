// import 'package:flutter/material.dart';

// void main() {
//   runApp(CommunityPage1());
// }

// class CommunityPage1 extends StatefulWidget {
//   @override
//   State<CommunityPage1> createState() => _CommunityPage1State();
// }

// class _CommunityPage1State extends State<CommunityPage1>
//     with SingleTickerProviderStateMixin {
//   List<Tab> myTab = [
//     Tab(text: "My Feed"),
//     Tab(text: "My Communities"),
//   ];

//   late TabController _tabController;
//   final TextEditingController _textController = TextEditingController();
//   final List<String> _feed = [];
//   String? _selectedCommunity = "Select community";

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   void _postToFeed() {
//     if (_textController.text.isNotEmpty && _selectedCommunity != null) {
//       setState(() {
//         _feed.add("${_selectedCommunity!}: ${_textController.text}");
//         _textController.clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.black),
//           title: Text(
//             "FILeats",
//             style: TextStyle(
//               fontFamily: "Gabarito",
//               fontWeight: FontWeight.bold,
//               color: Colors.orange,
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: Size.fromHeight(25.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.group, color: Colors.black),
//                     SizedBox(width: 15),
//                     Text(
//                       "Communities",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: "Gabarito",
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               TabBar(
//                 controller: _tabController,
//                 tabs: myTab,
//                 labelColor: Color(0xffF2A02D),
//                 labelStyle: TextStyle(
//                   fontFamily: "Gabarito",
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 indicatorColor: Color(0xffF2A02D),
//                 unselectedLabelColor: Colors.black,
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // Tab My Feed
//                     SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             // Input Post Container
//                             Container(
//                               padding: EdgeInsets.all(12.0),
//                               margin: EdgeInsets.only(bottom: 12.0),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.2),
//                                     spreadRadius: 2,
//                                     blurRadius: 6,
//                                     offset: Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   TextField(
//                                     controller: _textController,
//                                     decoration: InputDecoration(
//                                       hintText: 'Write your post here',
//                                       border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                     maxLines: 3,
//                                   ),
//                                   SizedBox(height: 10),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       DropdownButton<String>(
//                                         value: _selectedCommunity,
//                                         items: <String>[
//                                           "Select community",
//                                           "Lalapan Mbak Elly",
//                                           "Bangdor",
//                                           "Bu Indah"
//                                         ].map((String value) {
//                                           return DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Text(value),
//                                           );
//                                         }).toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedCommunity = value;
//                                           });
//                                         },
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: _postToFeed,
//                                         child: Text("Publish Post"),
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Color(0xffF2A02D),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Feed
//                             _feed.isEmpty
//                                 ? Text("No posts yet")
//                                 : ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: _feed.length,
//                                     itemBuilder: (context, index) {
//                                       return ListTile(
//                                         title: Text(_feed[index]),
//                                       );
//                                     },
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Tab My Communities
//                     Center(child: Text("My Communities")),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
