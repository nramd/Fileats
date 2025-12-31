import 'package:flutter/material.dart';

class FeedProvider extends ChangeNotifier {
  final List<Map<String, String>> _feed = [];

  List<Map<String, String>> get feed => _feed;

  void addPost(String community, String post) {
    _feed.add({"community": community, "post": post});
    notifyListeners();
  }
}
