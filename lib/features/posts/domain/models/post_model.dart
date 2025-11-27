import 'post_comment_model.dart';
import 'post_media_model.dart';

class PostModel {
  final String id;
  final String user;
  final String? group;
  final String postType;
  final String title;
  final String? description;
  final String? contentText;
  final String? youtubeLink;
  final String? tiktokLink;
  final DateTime createdAt;

  final List<PostMediaModel> media;
  final List<PostCommentModel> comments;

  final int likeCount;
  final int viewCount;
  final int shareCount;
  final int saveCount;

  final bool isLiked;
  final bool isSaved;

  PostModel({
    required this.id,
    required this.user,
    this.group,
    required this.postType,
    required this.title,
    this.description,
    this.contentText,
    this.youtubeLink,
    this.tiktokLink,
    required this.createdAt,
    required this.media,
    required this.comments,
    required this.likeCount,
    required this.viewCount,
    required this.shareCount,
    required this.saveCount,
    required this.isLiked,
    required this.isSaved,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      user: json['user'],
      group: json['group']?.toString(),
      postType: json['post_type'],
      title: json['title'],
      description: json['description'],
      contentText: json['content_text'],
      youtubeLink: json['youtube_link'],
      tiktokLink: json['tiktok_link'],
      createdAt: DateTime.parse(json['created_at']),
      media: (json['media'] as List)
          .map((e) => PostMediaModel.fromJson(e))
          .toList(),
      comments: (json['comments'] as List)
          .map((e) => PostCommentModel.fromJson(e))
          .toList(),
      likeCount: json['like_count'],
      viewCount: json['view_count'],
      shareCount: json['share_count'],
      saveCount: json['save_count'],
      isLiked: json['is_liked'],
      isSaved: json['is_saved'],
    );
  }
}
