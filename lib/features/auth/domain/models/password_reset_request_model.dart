// lib/features/auth/domain/models/password_reset_request_model.dart
class PasswordResetRequest {
  final String phoneNumber;
  final String newPassword;

  PasswordResetRequest({required this.phoneNumber, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'new_password': newPassword,
  };
}
