import 'package:flutter/material.dart';

class Favorites extends ChangeNotifier {
  List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;

  void addFavorite(dynamic article) {
    if (!_favorites.contains(article)) {
      _favorites.add(article);
      notifyListeners();
    }
  }

  void removeFavorite(dynamic article) {
    if (_favorites.contains(article)) {
      _favorites.remove(article);
      notifyListeners();
    }
  }
}
