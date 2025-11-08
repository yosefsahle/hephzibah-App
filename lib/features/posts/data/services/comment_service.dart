import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:hephzibah/features/posts/domain/models/comment_reply_model.dart';
import 'package:hephzibah/features/posts/domain/models/post_comment_model.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  // Create a comment
  static Future<void> createComment({
    required int postId,
    required String content,
  }) async {
    final String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('${Api().baseUrl}/posts/comment/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'post': postId, 'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create comment');
    }
  }

  // Create a reply
  static Future<void> createReply({
    required int commentId,
    required String content,
  }) async {
    final String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('${Api().baseUrl}/posts/reply/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'comment': commentId, 'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create reply');
    }
  }

  // Get comment detail
  static Future<PostCommentModel> getComment(int commentId) async {
    final String? token = await getAccessToken();

    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/comment/$commentId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return PostCommentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load comment');
    }
  }

  // Get reply detail
  static Future<CommentReplyModel> getReply(int replyId) async {
    final String? token = await getAccessToken();

    final response = await http.get(
      Uri.parse('${Api().baseUrl}/posts/reply/$replyId/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return CommentReplyModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load reply');
    }
  }
}
