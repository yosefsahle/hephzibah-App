import 'comment_reply_model.dart';

class PostCommentModel {
  final int id;
  final String user;
  final String content;
  final DateTime createdAt;
  final List<CommentReplyModel> replies;

  PostCommentModel({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.replies,
  });

  factory PostCommentModel.fromJson(Map<String, dynamic> json) {
    return PostCommentModel(
      id: json['id'],
      user: json['user'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      replies: (json['replies'] as List)
          .map((e) => CommentReplyModel.fromJson(e))
          .toList(),
    );
  }
}
