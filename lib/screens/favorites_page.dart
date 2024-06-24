import 'package:flutter/material.dart';
import 'news_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteArticles = [];

  @override
  void initState() {
    super.initState();
    // Carregar os artigos favoritos armazenados localmente
    loadFavoriteArticles();
  }

  void loadFavoriteArticles() {
    // Aqui você carregaria os dados reais armazenados localmente
    // Para fins de exemplo, estou inicializando com dados estáticos
    favoriteArticles = [
      {
        'title': 'Título do Artigo Favorito 1',
        'description': 'Descrição do artigo favorito 1.',
        'urlToImage': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Título do Artigo Favorito 2',
        'description': 'Descrição do artigo favorito 2.',
        'urlToImage': 'https://via.placeholder.com/150',
      },
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
