import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/data/services/comment_service.dart';
import 'package:hephzibah/features/posts/domain/models/post_comment_model.dart';
import 'package:hephzibah/features/posts/domain/models/comment_reply_model.dart';

/// State notifier for sending a new comment
final createCommentProvider =
    FutureProvider.family<void, ({int postId, String content})>((
      ref,
      data,
    ) async {
      await CommentService.createComment(
        postId: data.postId,
        content: data.content,
      );
    });

/// State notifier for sending a reply to a comment
final createReplyProvider =
    FutureProvider.family<void, ({int commentId, String content})>((
      ref,
      data,
    ) async {
      await CommentService.createReply(
        commentId: data.commentId,
        content: data.content,
      );
    });

/// Fetch a single comment by ID
final commentDetailProvider = FutureProvider.family<PostCommentModel, int>((
  ref,
  commentId,
) async {
  return await CommentService.getComment(commentId);
});

/// Fetch a single reply by ID
final replyDetailProvider = FutureProvider.family<CommentReplyModel, int>((
  ref,
  replyId,
) async {
  return await CommentService.getReply(replyId);
});
