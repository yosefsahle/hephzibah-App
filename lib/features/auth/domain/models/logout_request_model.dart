// lib/features/auth/domain/models/logout_request_model.dart
class LogoutRequest {
  final String refresh;

  LogoutRequest({required this.refresh});

  Map<String, dynamic> toJson() => {'refresh': refresh};
}
