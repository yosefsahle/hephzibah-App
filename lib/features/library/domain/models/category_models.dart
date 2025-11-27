class LibraryCategoryModel {
  final String id;
  final String name;
  final String imageOrIcon;

  LibraryCategoryModel({
    required this.id,
    required this.name,
    required this.imageOrIcon,
  });

  factory LibraryCategoryModel.fromJson(Map<String, dynamic> json) {
    return LibraryCategoryModel(
      id: json['id'],
      name: json['name'],
      imageOrIcon: json['image_or_icon'],
    );
  }
}
