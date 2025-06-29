class ResetPasswordModel {
  final String phoneNumber;
  final String newPassword;

  ResetPasswordModel({required this.phoneNumber, required this.newPassword});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'new_password': newPassword,
  };
}
