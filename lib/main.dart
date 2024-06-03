// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/news_home_page.dart';
import 'screens/favorites_page.dart';
import 'services/news_service.dart';
import 'models/favorites.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Favorites(),
      child: NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsHomePage(),
      routes: {
        '/favorites': (context) => FavoritesPage(),
      },
    );
  }
}
