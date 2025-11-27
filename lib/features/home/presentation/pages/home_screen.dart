import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/core/theme/text_styles.dart';
import 'package:hephzibah/features/home/presentation/widgets/banner_carousel_widget.dart';
import 'package:hephzibah/features/home/presentation/widgets/home_category_button.dart';
import 'package:hephzibah/features/home/presentation/widgets/posts_carosel_home.dart';
import 'package:hephzibah/features/posts/presentation/providers/home_feed_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPosts = ref.watch(latestPostsProvider);
    final trendingPosts = ref.watch(trendingPostsProvider);
    final personalizedPosts = ref.watch(personalizedPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hephzibah Home', style: AppTextStyles.headlineSmall),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      drawer: const Drawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(latestPostsProvider);
          ref.invalidate(trendingPostsProvider);
          ref.invalidate(personalizedPostsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBannerCarousel(),
              const SizedBox(height: 10),
              const HomeCategoryButton(),

              // Latest Posts
              latestPosts.when(
                data: (posts) =>
                    HorizontalPostCarousel(posts: posts, title: 'Latest Posts'),
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 180,
                  child: Center(child: Text('Error: $err')),
                ),
              ),
              const SizedBox(height: 20),

              // Trending Posts
              trendingPosts.when(
                data: (posts) => HorizontalPostCarousel(
                  posts: posts,
                  title: 'Trending Posts',
                ),
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 180,
                  child: Center(child: Text('Error: $err')),
                ),
              ),
              const SizedBox(height: 20),

              // Personalized Posts
              personalizedPosts.when(
                data: (posts) => HorizontalPostCarousel(
                  posts: posts,
                  title: 'Recommended for You',
                ),
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 180,
                  child: Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
