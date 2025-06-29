class OtpVerifyModel {
  final String phoneNumber;
  final String code;

  OtpVerifyModel({required this.phoneNumber, required this.code});

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber, 'code': code};
}
