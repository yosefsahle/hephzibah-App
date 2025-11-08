import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/data/services/home_feed_service.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';

/// 📌 Latest posts (unauthenticated)
final latestPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return await HomeFeedService.fetchLatest();
});

/// 🚀 Trending posts (unauthenticated)
final trendingPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return await HomeFeedService.fetchTrending();
});

/// 💡 Personalized posts (authenticated)
final personalizedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return await HomeFeedService.fetchPersonalized();
});

/// 🎥 Video-based posts (unauthenticated)
final videoPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return await HomeFeedService.fetchVideoPosts();
});
