import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MediaService {
  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  static Future<void> uploadMedia({
    required int postId,
    required File file,
    required String mediaType, // image, video, audio, youtube, tiktok
  }) async {
    final String? token = await getAccessToken();

    final uri = Uri.parse('${Api().baseUrl}/posts/media/upload/');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeSplit = mimeType.split('/');

    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
        contentType: MediaType(mimeSplit[0], mimeSplit[1]),
      ),
    );

    // Add other fields
    request.fields['post'] = postId.toString();
    request.fields['media_type'] = mediaType;

    final response = await request.send();

    if (response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Media upload failed: $respStr');
    }
  }
}
