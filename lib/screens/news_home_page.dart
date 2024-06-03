import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/news_service.dart';
import 'news_detail_page.dart';
import 'favorites_page.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({Key? key}) : super(key: key);

  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final NewsService _newsService = NewsService();
  late Future<List<dynamic>> _newsArticles;
  String _searchQuery = '';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                }),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: NewsSearchDelegate(_newsService));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _newsArticles,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load news'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var article = snapshot.data![index];
                      var publishedAt = article['publishedAt'] ?? '';
                      var formattedDate = '';

                      if (publishedAt is String && publishedAt.isNotEmpty) {
                        try {
                          formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                              .format(DateTime.parse(publishedAt));
                        } catch (e) {
                          print('Failed to parse date: $e');
                        }
                      }

                      return NewsCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                title: article['title'] ?? '',
                                description: article['description'] ?? '',
                                imageUrl: article['urlToImage'] ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),
                          );
                        },
                        formattedDate: formattedDate,
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
}

class NewsCard extends StatelessWidget {
  final dynamic article;
  final VoidCallback onTap;
  final String formattedDate;

  const NewsCard({
    Key? key,
    required this.article,
    required this.onTap,
    required this.formattedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article['urlToImage'] ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Published at: $formattedDate',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Source: ${article['source']['name'] ?? ''}',
                    style: const TextStyle(color: Colors.grey),
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

class NewsSearchDelegate extends SearchDelegate {
  final NewsService newsService;

  NewsSearchDelegate(this.newsService);

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
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
          return const Center(child: Text('Failed to load news'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var article = snapshot.data![index];
              var publishedAt = article['publishedAt'] ?? '';
              var formattedDate = '';
              if (publishedAt is String && publishedAt.isNotEmpty) {
                try {
                  formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                      .format(DateTime.parse(publishedAt));
                } catch (e) {
                  print('Failed to parse date: $e');
                }
              }

              return NewsCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(
                        title: article['title'] ?? '',
                        description: article['description'] ?? '',
                        imageUrl: article['urlToImage'] ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                  );
                },
                formattedDate: formattedDate,
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
