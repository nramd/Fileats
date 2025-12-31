import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../providers/feed_provider.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  
  List<Tab> myTab = [
    Tab(text: "My Feed"),
    Tab(text: "My Communities"),
  ];

  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  String? _selectedCommunity = "Add Your Post in";
  bool _isPosting = false; // Untuk loading saat posting

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // FUNGSI POSTING BARU
  void _postToFeed(BuildContext context) async {
    if (_textController.text.isEmpty) return;
    if (_selectedCommunity == "Add Your Post in") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pilih komunitas dulu!")));
      return;
    }

    setState(() => _isPosting = true);

    try {
      // Panggil Provider untuk kirim ke Firestore
      await Provider.of<FeedProvider>(context, listen: false)
          .addPost(_selectedCommunity!, _textController.text);
      
      _textController.clear();
      FocusScope.of(context).unfocus(); // Tutup keyboard
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Berhasil diposting!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset("assets/images/assets/FILeats.png", height: 30),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(25.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/assets/communities.png", width: 20),
                        SizedBox(width: 15),
                        Text(
                          "Communities",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Gabarito",
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // AVATAR TOKO HEADER
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    _buildAvatarToko("Mbak Elly", "assets/images/assets/avatarToko/wrung_m_elly.jpg"),
                    _buildAvatarToko("Bangdor", "assets/images/assets/avatarToko/wrung_bangdor.jpg"),
                    _buildAvatarToko("Bu Indah", "assets/images/assets/avatarToko/wrung_bindah.jpg"),
                    _buildAvatarToko("Coming Soon", "assets/images/assets/avatarToko/comingsoon.jpg"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            
            TabBar(
              controller: _tabController,
              tabs: myTab,
              labelColor: Color(0xffF2A02D),
              labelStyle: TextStyle(
                fontFamily: "Gabarito",
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Color(0xffF2A02D),
              unselectedLabelColor: Colors.black,
            ),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // --- TAB 1: MY FEED (REALTIME) ---
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // INPUT POST
                          Container(
                            padding: EdgeInsets.all(12.0),
                            margin: EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                      hintText: 'Write your post here',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Icon(Icons.account_circle_outlined),
                                      )),
                                  maxLines: null,
                                  minLines: 1,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 12),
                                        Icon(Icons.public),
                                        SizedBox(width: 10),
                                        DropdownButton<String>(
                                          style: _selectedCommunity == "Add Your Post in"
                                              ? TextStyle(
                                                  fontFamily: "Gabarito",
                                                  fontWeight: FontWeight.w100,
                                                  color: Color(0xFFF2A02D))
                                              : TextStyle(
                                                  fontFamily: "Gabarito",
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.black.withOpacity(0.5)),
                                          value: _selectedCommunity,
                                          items: <String>[
                                            "Add Your Post in",
                                            "Lalapan Mbak Elly",
                                            "Bangdor",
                                            "Bu Indah"
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedCommunity = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: _isPosting ? null : () => _postToFeed(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xffF2A02D),
                                      ),
                                      child: _isPosting 
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : Text(
                                            "Publish Post",
                                            style: TextStyle(
                                                fontFamily: "Gabarito",
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // --- STREAM BUILDER (PENGGANTI CONSUMER) ---
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('community_posts')
                                .orderBy('createdAt', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error loading posts");
                              }
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }

                              final data = snapshot.data?.docs ?? [];

                              if (data.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text("Belum ada postingan. Jadilah yang pertama!", style: TextStyle(color: Colors.grey)),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  // Ambil data per dokumen
                                  final post = data[index].data() as Map<String, dynamic>;
                                  
                                  // Ambil field (gunakan default value jika null)
                                  final communityName = post['community'] ?? 'Community';
                                  final userName = post['userName'] ?? 'User';
                                  final postContent = post['post'] ?? '';
                                  final location = post['location'] ?? 'Malang, Indonesia';

                                  return Container(
                                    padding: EdgeInsets.all(12.0),
                                    margin: EdgeInsets.only(bottom: 12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 8),
                                            Text(
                                              "Posted in ",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                            ),
                                            Text(
                                              communityName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xffF2A02D),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(color: Colors.grey, thickness: 0.3),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            SizedBox(width: 8),
                                            Icon(Icons.account_circle, size: 40),
                                            SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userName, // Nama dinamis dari database
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  location,
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            postContent,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Divider(color: Colors.grey, thickness: 0.3),
                                        // Bagian Bawah (Like, Comment, Share) - Masih Mockup UI
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.favorite, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Text("0", style: TextStyle(color: Colors.grey)),
                                                    ],
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.comment, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Text("0", style: TextStyle(color: Colors.grey)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 120),
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.ios_share_rounded, size: 16, color: Colors.grey),
                                                      SizedBox(width: 4),
                                                      Text("Share", style: TextStyle(fontFamily: "Gabarito", fontSize: 16, color: Colors.grey)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- TAB 2: MY COMMUNITIES (TETAP SAMA) ---
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: Column(
                        children: [
                          _buildCommunityToko("Lalapan Mbak Elly", "assets/images/assets/avatarToko/wrung_m_elly.jpg", 4.9, "234"),
                          _buildCommunityToko("Bangdor", "assets/images/assets/avatarToko/wrung_bangdor.jpg", 4.5, "312"),
                          _buildCommunityToko("Bu Indah", "assets/images/assets/avatarToko/wrung_bindah.jpg", 4.3, "213"),
                          _buildCommunityToko("Coming Soon", "assets/images/assets/avatarToko/comingsoon.jpg", 0, "0"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (TETAP SAMA) ---
  Widget _buildAvatarToko(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 3, blurRadius: 6)],
                ),
              ),
              SizedBox(height: 4.0),
              Text(label, style: TextStyle(fontSize: 12, fontFamily: "Gabarito", fontWeight: FontWeight.bold, color: Colors.black))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityToko(String label, String imagePath, double rating, String jMember) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 360,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 5)],
        ),
        child: Row(
          children: [
            SizedBox(width: 32.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 28.0, fontFamily: "Gabarito", fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 2.0),
                Text('⭐ ${rating.toString()} (${jMember} Members)', style: TextStyle(fontSize: 14.0, fontFamily: "Gabarito", fontWeight: FontWeight.w100, color: Colors.white)),
                SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {},
                  child: Text("View Community", style: TextStyle(fontSize: 14.0, fontFamily: "Gabarito", fontWeight: FontWeight.bold, color: Color(0xffF2A02D))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}