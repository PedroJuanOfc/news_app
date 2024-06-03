import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = '9c6362fedb2a404d943e8c539cce2df4';

  Future<List<dynamic>> fetchNews(
      {String query = '', String category = ''}) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    if (query.isNotEmpty) {
      url += '&q=$query';
    }
    if (category.isNotEmpty) {
      url += '&category=$category';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
