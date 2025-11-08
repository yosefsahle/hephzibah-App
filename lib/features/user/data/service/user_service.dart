import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:hephzibah/features/auth/data/services/auth_service.dart';
import 'package:hephzibah/features/auth/domain/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserService {
  final storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  // final token = AuthService().getAccessToken();
  static String usersUrl = '${Api().baseUrl}/users';

  Future<UserModel> getCurrentUser() async {
    final String? token = await getAccessToken();

    final response = await http.get(
      Uri.parse('$usersUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String? email,
    required String? church,
    required String? location,
    required String? occupation,
    required String? bio,
    File? profileImage,
  }) async {
    final uri = Uri.parse("$usersUrl/user/profile/update/");
    final String? token = await getAccessToken();

    final request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['first_name'] = firstName
      ..fields['last_name'] = lastName;

    if (email != null) request.fields['email'] = email;
    if (church != null) request.fields['church'] = church;
    if (location != null) request.fields['location'] = location;
    if (occupation != null) request.fields['occupation'] = occupation;
    if (bio != null) request.fields['bio'] = bio;

    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 204) {
      final error = await response.stream.bytesToString();
      throw Exception('Failed to update profile: $error');
    }
  }
}
