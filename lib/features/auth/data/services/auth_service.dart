// lib/features/auth/data/services/auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hephzibah/core/constants/api_contants.dart';
import 'package:hephzibah/features/auth/domain/models/logout_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/otp_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/password_reset_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/registration_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage;

  AuthService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static String usersUrl = '${Api().baseUrl}/users';

  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$usersUrl/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(jsonData);

      // Store tokens securely
      await _secureStorage.write(
        key: _accessTokenKey,
        value: loginResponse.access,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: loginResponse.refresh,
      );

      return loginResponse;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> logout(LogoutRequest request) async {
    final url = Uri.parse('$usersUrl/logout/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
    } else {
      throw Exception('Logout failed: ${response.body}');
    }
  }

  Future<void> refreshtokens(String refreshToken) async {
    final url = Uri.parse('$usersUrl/token/refresh/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refresh": refreshToken}),
    );

    if (response.statusCode == 200) {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      final jsonData = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(jsonData);

      await _secureStorage.write(
        key: _accessTokenKey,
        value: loginResponse.access,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: loginResponse.refresh,
      );
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Send OTP for registration or password reset
  Future<OtpResponse> sendOtp(
    OtpRequest request, {
    required bool isRegistration,
  }) async {
    final endpoint = isRegistration
        ? 'otp/request-register/'
        : 'otp/request-reset/';
    final url = Uri.parse('$usersUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  // Verify OTP
  Future<OtpResponse> verifyOtp(OtpVerificationRequest request) async {
    final url = Uri.parse('$usersUrl/otp/verify/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<OtpResponse> resetPassword(PasswordResetRequest request) async {
    final url = Uri.parse('$usersUrl/reset-password/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: request.toJson(),
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw Exception('Password reset failed: ${response.body}');
    }
  }

  Future<UserModel> registerUser(RegistrationRequest request) async {
    final uri = Uri.parse('$usersUrl/register/');
    final multipartRequest = http.MultipartRequest('POST', uri);

    // Add text fields
    multipartRequest.fields.addAll(request.toFields());

    // Add file if present
    if (request.profileImage != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          request.profileImage!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await multipartRequest.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }
}
