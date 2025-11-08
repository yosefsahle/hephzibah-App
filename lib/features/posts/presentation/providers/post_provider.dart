import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/data/services/post_service.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';

/// Provider to fetch all posts with optional search and postType filter
final postListProvider =
    FutureProvider.family<
      List<PostModel>,
      ({String? search, String? postType})
    >((ref, params) {
      return PostService.getPosts(
        search: params.search,
        postType: params.postType,
      );
    });

/// Provider to fetch a single post by ID
final postDetailProvider = FutureProvider.family<PostModel, int>((ref, postId) {
  return PostService.getPostDetail(postId);
});

/// Provider to create a post
final createPostProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  postData,
) {
  return PostService.createPost(postData);
});

/// Provider to delete a post by ID
final deletePostProvider = FutureProvider.family<void, int>((ref, postId) {
  return PostService.deletePost(postId);
});
