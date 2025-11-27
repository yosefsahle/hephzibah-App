import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:hephzibah/features/groups/domain/models/group_model.dart';
import 'package:http/http.dart' as http;

class GroupService {
  static String get groupUrl {
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

  /// Get all groups (Only accessible to system super admin)
  static Future<List<Group>> getGroups({int page = 1, int limit = 20}) async {
    try {
      print('=== API CALL: getGroups ===');
      print('Page: $page, Limit: $limit');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/group/').replace(
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      print('API URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('API Groups Count: ${data.length}');

        if (data.isNotEmpty) {
          print('First group structure: ${data[0]}');
        }

        return data.map((e) => Group.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only system super admin can access groups list',
        );
      } else {
        throw Exception(
          'Failed to load Groups: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error loading Groups: $e');
    }
  }

  /// Get a single group by ID (Only group super admin can access)
  static Future<Group> getGroup(String groupId) async {
    try {
      print('=== API CALL: getGroup ===');
      print('GroupId: $groupId');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/$groupId/');

      print('API URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Group.fromJson(data);
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only group super admin can access this group',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Group not found');
      } else {
        throw Exception(
          'Failed to load Group: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error loading Group: $e');
    }
  }

  /// Create a new group (Only system super admin can create)
  static Future<Group> createGroup(Group group) async {
    try {
      print('=== API CALL: createGroup ===');
      print('Group Data: ${group.toJson()}');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/group/');

      final response = await http.post(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(group.toJson()),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Group.fromJson(data);
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only system super admin can create groups',
        );
      } else {
        throw Exception(
          'Failed to create Group: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error creating Group: $e');
    }
  }

  /// Update a group (Only group super admin can update)
  static Future<Group> updateGroup(Group group) async {
    try {
      print('=== API CALL: updateGroup ===');
      print('Group ID: ${group.id}');
      print('Group Data: ${group.toJson()}');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/${group.id}/');

      final response = await http.put(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(group.toJson()),
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Group.fromJson(data);
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only group super admin can update this group',
        );
      } else {
        throw Exception(
          'Failed to update Group: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error updating Group: $e');
    }
  }

  /// Delete a group (Only group super admin can delete)
  static Future<void> deleteGroup(String groupId) async {
    try {
      print('=== API CALL: deleteGroup ===');
      print('GroupId: $groupId');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/$groupId/');

      final response = await http.delete(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only group super admin can delete this group',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Group not found');
      } else {
        throw Exception(
          'Failed to delete Group: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error deleting Group: $e');
    }
  }

  /// Search groups (Only system super admin can search)
  static Future<List<Group>> searchGroups({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      print('=== API CALL: searchGroups ===');
      print('Query: $query');
      print('Page: $page, Limit: $limit');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/group/').replace(
        queryParameters: {
          'search': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('API URL: ${uri.toString()}');

      final response = await http.get(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Group.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only system super admin can search groups',
        );
      } else {
        throw Exception(
          'Failed to search Groups: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error searching Groups: $e');
    }
  }

  /// End a discussion session (Only group super admin or admin with permission)
  static Future<void> endDiscussion(String discussionId) async {
    try {
      print('=== API CALL: endDiscussion ===');
      print('DiscussionId: $discussionId');

      final String? token = await getAccessToken();
      final uri = Uri.parse('$groupUrl/groups/discussion/$discussionId/end/');

      final response = await http.post(
        uri,
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 403) {
        throw Exception(
          'Permission denied: Only group super admin or admin with scheduling permission can end discussions',
        );
      } else if (response.statusCode == 404) {
        throw Exception('Discussion not found');
      } else {
        throw Exception(
          'Failed to end discussion: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error ending discussion: $e');
    }
  }
}
