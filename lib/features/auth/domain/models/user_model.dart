// lib/features/auth/domain/models/user_model.dart
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String phoneNumber;
  final String? email;
  final String? church;
  final String? location;
  final String? occupation;
  final String? bio;
  final String profileImage;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.profileImage,
    this.email,
    this.church,
    this.location,
    this.occupation,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    firstName: json['first_name'],
    lastName: json['last_name'],
    age: json['age'],
    gender: json['gender'],
    phoneNumber: json['phone_number'],
    email: json['email'],
    church: json['church'],
    location: json['location'],
    occupation: json['occupation'],
    bio: json['bio'],
    profileImage: json['profile_image'],
  );
}
