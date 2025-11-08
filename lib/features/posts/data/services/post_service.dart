import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:http/http.dart' as http;
import '../../../posts/domain/models/post_model.dart';

class PostService {
  static String postsUrl = Api().baseUrl;
  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  static Future<List<PostModel>> getPosts({
    String? search,
    String? postType,
  }) async {
    final String? token = await getAccessToken();
    final uri = Uri.parse('$postsUrl/posts/').replace(
      queryParameters: {
        if (search != null) 'search': search,
        if (postType != null) 'post_type': postType,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PostModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<PostModel> getPostDetail(int id) async {
    final String? token = await getAccessToken();
    final response = await http.get(
      Uri.parse('$postsUrl/posts/$id/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return PostModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post detail');
    }
  }

  // Stub for creating a post (to be implemented when you give the creation format)
  static Future<void> createPost(Map<String, dynamic> data) async {
    final String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('$postsUrl/posts/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create post');
    }
  }

  static Future<void> deletePost(int id) async {
    final String? token = await getAccessToken();

    final response = await http.delete(
      Uri.parse('$postsUrl/posts/$id/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete post');
    }
  }
}
