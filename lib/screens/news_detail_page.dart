import 'package:flutter/material.dart';
import '../models/favorites.dart';
import 'package:provider/provider.dart';

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool isFavorite;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false, // Padrão é falso
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícia Completa'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl,
                fit: BoxFit.cover, width: double.infinity, height: 200),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  isFavorite
                      ? ElevatedButton(
                          onPressed: () {
                            Provider.of<Favorites>(context, listen: false)
                                .removeFavorite({
                              'title': title,
                              'description': description,
                              'urlToImage': imageUrl,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removido dos favoritos'),
                              ),
                            );
                            Navigator.pop(
                                context); // Voltar para a tela de favoritos
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.remove_circle),
                              SizedBox(width: 10),
                              Text('Remover dos Favoritos'),
                            ],
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Provider.of<Favorites>(context, listen: false)
                                .addFavorite({
                              'title': title,
                              'description': description,
                              'urlToImage': imageUrl,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Adicionado aos favoritos'),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite),
                              SizedBox(width: 10),
                              Text('Adicionar aos Favoritos'),
                            ],
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
}
