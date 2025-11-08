// lib/features/auth/domain/models/login_response_model.dart
class LoginResponse {
  final String refresh;
  final String access;

  LoginResponse({required this.refresh, required this.access});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
    );
  }
}
