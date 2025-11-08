import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:http/http.dart' as http;

class InteractionService {
  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  static Future<String> interact({
    required int postId,
    required String type, // one of: view, like, share, save
  }) async {
    final String? token = await getAccessToken();

    final response = await http.post(
      Uri.parse('${Api().baseUrl}/posts/interact/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'post': postId, 'type': type}),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return jsonBody['detail'] ?? 'Interaction recorded';
    } else {
      throw Exception('Failed to interact with post: ${response.body}');
    }
  }
}

// Usage of This service
// await InteractionService.interact(postId: 1, type: 'like');
// await InteractionService.interact(postId: 1, type: 'save');
// await InteractionService.interact(postId: 1, type: 'view');
