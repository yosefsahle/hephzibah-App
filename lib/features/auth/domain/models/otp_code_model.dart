// lib/features/auth/domain/models/otp_code_model.dart
class OtpCode {
  final String phoneNumber;
  final String code;
  final int attemptCount;
  final DateTime createdAt;

  OtpCode({
    required this.phoneNumber,
    required this.code,
    required this.attemptCount,
    required this.createdAt,
  });

  factory OtpCode.fromJson(Map<String, dynamic> json) {
    return OtpCode(
      phoneNumber: json['phone_number'] as String,
      code: json['code'] as String,
      attemptCount: json['attempt_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'code': code,
    'attempt_count': attemptCount,
    'created_at': createdAt.toIso8601String(),
  };

  bool get isExpired {
    return DateTime.now().isAfter(createdAt.add(const Duration(minutes: 5)));
  }
}
