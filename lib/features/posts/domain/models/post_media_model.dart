class PostMediaModel {
  final String id;
  final String mediaType;
  final String? file;
  final String? externalLink;

  PostMediaModel({
    required this.id,
    required this.mediaType,
    this.file,
    this.externalLink,
  });

  factory PostMediaModel.fromJson(Map<String, dynamic> json) {
    return PostMediaModel(
      id: json['id'],
      mediaType: json['media_type'],
      file: json['file'],
      externalLink: json['external_link'],
    );
  }
}
