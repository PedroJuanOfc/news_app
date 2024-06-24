import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  final List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;

  void addFavorite(dynamic article) {
    if (!_favorites.any((element) => _areArticlesEqual(element, article))) {
      _favorites.add(article);
      notifyListeners();
    }
  }

  void removeFavorite(dynamic article) {
    _favorites.removeWhere((element) => _areArticlesEqual(element, article));
    notifyListeners();
  }

  bool _areArticlesEqual(dynamic a, dynamic b) {
    return a['title'] == b['title'] &&
        a['description'] == b['description'] &&
        a['urlToImage'] == b['urlToImage'];
  }
}
