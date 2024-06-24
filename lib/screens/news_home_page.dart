import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/news_service.dart';
import 'news_detail_page.dart';
import 'favorites_page.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final NewsService _newsService = NewsService();
  late Future<List<dynamic>> _newsArticles;
  final String _searchQuery = '';
  String _category = '';

  @override
  void initState() {
    super.initState();
    _newsArticles = _newsService.fetchNews();
  }

  void _filterNews() {
    setState(() {
      _newsArticles =
          _newsService.fetchNews(query: _searchQuery, category: _category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: NewsSearchDelegate(_newsService),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Navigation bar for categories
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton('general', 'Geral'),
                  _buildCategoryButton('sports', 'Esporte'),
                  _buildCategoryButton('technology', 'Tecnologia'),
                  _buildCategoryButton('entertainment', 'Entretenimento'),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _newsArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Falha ao carregar notícias'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma notícia disponível'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var article = snapshot.data![index];
                      var publishedAt = article['publishedAt'] ?? '';
                      var formattedDate = '';

                      if (publishedAt is String && publishedAt.isNotEmpty) {
                        var date = DateTime.parse(publishedAt);
                        formattedDate =
                            DateFormat('dd/MM/yyyy HH:mm').format(date);
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                title: article['title'] ?? '',
                                description: article['description'] ?? '',
                                imageUrl: article['urlToImage'] ??
                                    'lib/assets/placeholder.png',
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'lib/assets/placeholder1.png',
                                image: article['urlToImage'] ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'lib/assets/placeholder.png',
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
                                      article['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      article['description'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _category = category;
            _filterNews();
          });
        },
        child: Text(label),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final NewsService newsService;

  NewsSearchDelegate(this.newsService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: newsService.fetchNews(query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Falha ao carregar notícias'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma notícia disponível'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var article = snapshot.data![index];
              var publishedAt = article['publishedAt'] ?? '';
              var formattedDate = '';

              if (publishedAt is String && publishedAt.isNotEmpty) {
                var date = DateTime.parse(publishedAt);
                formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
              }

              String imageUrl = article['urlToImage'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(
                        title: article['title'] ?? '',
                        description: article['description'] ?? '',
                        imageUrl: imageUrl.isNotEmpty
                            ? imageUrl
                            : 'lib/assets/placeholder.png',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder: 'lib/assets/placeholder.png',
                        image: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'lib/assets/placeholder.png',
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
                              article['title'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              article['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
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
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
