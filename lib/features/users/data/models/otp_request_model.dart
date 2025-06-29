class OtpRequestModel {
  final String phoneNumber;

  OtpRequestModel({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'phone_number': phoneNumber};
}
