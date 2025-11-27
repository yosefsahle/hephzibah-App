class Group {
  final String id;
  final String name;
  final String description;
  final String profilePicture;
  final String groupType;
  final String superAdmin;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.profilePicture,
    required this.groupType,
    required this.superAdmin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      profilePicture: json['profile_picture'] as String,
      groupType: json['group_type'] as String,
      superAdmin: json['super_admin'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'profile_picture': profilePicture,
      'group_type': groupType,
      'super_admin': superAdmin,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? profilePicture,
    String? groupType,
    String? superAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      profilePicture: profilePicture ?? this.profilePicture,
      groupType: groupType ?? this.groupType,
      superAdmin: superAdmin ?? this.superAdmin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
