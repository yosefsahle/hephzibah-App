import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/post_model.dart';

class HomeFeedService {
  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  // Latest posts (no auth required)
  static Future<List<PostModel>> fetchLatest() async {
    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/latest/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load latest posts');
    }
  }

  // Trending posts (no auth required)
  static Future<List<PostModel>> fetchTrending() async {
    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/trending/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending posts');
    }
  }

  // Personalized posts (auth required)
  static Future<List<PostModel>> fetchPersonalized() async {
    String? token = await getAccessToken();

    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/personalized/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load personalized posts');
    }
  }

  // Video posts (no auth required)
  static Future<List<PostModel>> fetchVideoPosts() async {
    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/videos/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load video posts');
    }
  }
}
