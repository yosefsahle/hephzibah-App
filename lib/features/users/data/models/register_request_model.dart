class RegisterRequestModel {
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String password;
  final String? email;
  final String? church;
  final String? location;
  final String? occupation;
  final String? bio;

  RegisterRequestModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.password,
    this.email,
    this.church,
    this.location,
    this.occupation,
    this.bio,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'age': age,
    'gender': gender,
    'phone_number': phoneNumber,
    'password': password,
    'email': email,
    'church': church,
    'location': location,
    'occupation': occupation,
    'bio': bio,
  };
}
