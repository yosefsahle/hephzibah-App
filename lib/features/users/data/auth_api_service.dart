import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';
import 'models/login_request_model.dart';
import 'models/login_response_model.dart';
import 'models/register_request_model.dart';
import 'models/user_model.dart';
import 'models/otp_request_model.dart';
import 'models/otp_verify_model.dart';

class AuthApiService {
  final http.Client client;

  AuthApiService({http.Client? client}) : client = client ?? http.Client();

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/login/');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<UserModel> getUserProfile(String accessToken) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/me/');
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile: ${response.body}');
    }
  }

  Future<void> register(RegisterRequestModel request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/register/');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<void> requestOtp(OtpRequestModel request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/otp/request/');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('OTP request failed: ${response.body}');
    }
  }

  Future<void> verifyOtp(OtpVerifyModel request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/otp/verify/');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('OTP verification failed: ${response.body}');
    }
  }
}
