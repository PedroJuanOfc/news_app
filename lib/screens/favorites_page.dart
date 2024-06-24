import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorites.dart';
import 'news_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: Consumer<Favorites>(
        builder: (context, favorites, child) {
          final favoriteArticles = favorites.favorites;

          if (favoriteArticles.isEmpty) {
            return const Center(
              child: Text('Nenhuma notícia nos favoritos'),
            );
          }

          return ListView.builder(
            itemCount: favoriteArticles.length,
            itemBuilder: (context, index) {
              var article = favoriteArticles[index];
              String imageUrl =
                  article['urlToImage'] ?? 'https://via.placeholder.com/150';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(
                        title: article['title'],
                        description: article['description'],
                        imageUrl: imageUrl,
                        isFavorite: true, // Passando a flag
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              article['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
