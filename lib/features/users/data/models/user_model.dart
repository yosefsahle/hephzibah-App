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
  final String? profileImage;
  final String username;
  final String role;
  final DateTime dateJoined;
  final DateTime lastActive;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.username,
    required this.role,
    required this.dateJoined,
    required this.lastActive,
    this.email,
    this.church,
    this.location,
    this.occupation,
    this.bio,
    this.profileImage,
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
    username: json['username'],
    role: json['role'],
    dateJoined: DateTime.parse(json['date_joined']),
    lastActive: DateTime.parse(json['last_active']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'age': age,
    'gender': gender,
    'phone_number': phoneNumber,
    'email': email,
    'church': church,
    'location': location,
    'occupation': occupation,
    'bio': bio,
    'profile_image': profileImage,
    'username': username,
    'role': role,
    'date_joined': dateJoined.toIso8601String(),
    'last_active': lastActive.toIso8601String(),
  };
}
