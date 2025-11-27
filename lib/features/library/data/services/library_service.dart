import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:hephzibah/features/library/domain/models/category_models.dart';
import 'package:hephzibah/features/library/domain/models/library_item_model.dart';
import 'package:http/http.dart' as http;

class LibraryService {
  static String get libraryUrl {
    final baseUrl = Api().baseUrl;
    if (baseUrl.isEmpty) {
      throw Exception('Base URL is not configured');
    }
    return baseUrl;
  }

  static const storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';

  static Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  static Future<List<LibraryCategoryModel>> getTopCategories() async {
    try {
      final String? token = await getAccessToken();
      final uri = Uri.parse('$libraryUrl/library/top-categories/');
      final response = await http.get(
        uri,
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => LibraryCategoryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load Top Categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading Top Categories: $e');
    }
  }

  static Future<List<LibraryCategoryModel>> getMiddleCategories(
    String topCategoryId,
  ) async {
    try {
      final String? token = await getAccessToken();
      final uri = Uri.parse(
        '$libraryUrl/library/middle-categories/by-top-category/${topCategoryId}/',
      ).replace();

      final response = await http.get(
        uri,
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("==================Here is The Problem==================");
        print("top category iD ${topCategoryId}");
        print('Response Body: ${response.body}');
        print('Middle Categories Data: $data');

        return data.map((e) => LibraryCategoryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load Middle Categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading Middle Categories: $e');
    }
  }

  static Future<List<LibraryCategoryModel>> getSubCategories(
    String middleCategoryId,
  ) async {
    try {
      final String? token = await getAccessToken();
      final uri = Uri.parse(
        '$libraryUrl/library/sub-categories/by-middle-category/${middleCategoryId}/',
      ).replace();

      final response = await http.get(
        uri,
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => LibraryCategoryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load Sub Categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading Sub Categories: $e');
    }
  }

  static Future<List<LibraryItemModel>> getLibraryItems({
    required String subCategoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final String? token = await getAccessToken();
      final uri = Uri.parse('$libraryUrl/library/libraries/').replace(
        queryParameters: {
          'sub_category_id': subCategoryId,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('API URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('API Library Items Count: ${data.length}');

        // Print first item for debugging
        if (data.isNotEmpty) {
          print('First item structure: ${data[0]}');
        }

        return data.map((e) => LibraryItemModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load Library Items: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error loading Library Items: $e');
    }
  }

  static Future<List<LibraryItemModel>> searchLibraryItems({
    required String query,
    String? subCategoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final String? token = await getAccessToken();
      final Map<String, String> queryParams = {
        'search': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (subCategoryId != null) {
        queryParams['sub_category_id'] = subCategoryId;
      }

      final uri = Uri.parse(
        '$libraryUrl/library/libraries/',
      ).replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: token != null
            ? {'Authorization': 'Bearer $token', 'Accept': 'application/json'}
            : {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => LibraryItemModel.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to search Library Items: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching Library Items: $e');
    }
  }
}
