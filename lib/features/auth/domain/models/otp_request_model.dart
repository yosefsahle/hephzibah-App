// lib/features/auth/domain/models/otp_request_model.dart
class OtpRequest {
  final String phoneNumber;

  OtpRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber};
}

// lib/features/auth/domain/models/otp_verification_request_model.dart
class OtpVerificationRequest {
  final String phoneNumber;
  final String code;

  OtpVerificationRequest({required this.phoneNumber, required this.code});

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber, 'code': code};
}

// Response model (generic detail message)
class OtpResponse {
  final String detail;

  OtpResponse({required this.detail});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(detail: json['detail']);
  }
}
