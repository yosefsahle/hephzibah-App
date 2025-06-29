class LoginRequestModel {
  final String phoneNumber;
  final String password;

  LoginRequestModel({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'password': password,
  };
}
