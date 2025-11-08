// lib/features/auth/domain/models/registration_request_model.dart
import 'dart:io';

class RegistrationRequest {
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
  final File? profileImage;

  RegistrationRequest({
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
    this.profileImage,
  });

  Map<String, String> toFields() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'age': age.toString(),
      'gender': gender,
      'phone_number': phoneNumber,
      'password': password,
      if (email != null) 'email': email!,
      if (church != null) 'church': church!,
      if (location != null) 'location': location!,
      if (occupation != null) 'occupation': occupation!,
      if (bio != null) 'bio': bio!,
    };
  }
}
