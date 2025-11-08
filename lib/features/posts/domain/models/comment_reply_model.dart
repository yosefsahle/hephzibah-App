class CommentReplyModel {
  final int id;
  final String user;
  final String content;
  final DateTime createdAt;

  CommentReplyModel({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory CommentReplyModel.fromJson(Map<String, dynamic> json) {
    return CommentReplyModel(
      id: json['id'],
      user: json['user'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
