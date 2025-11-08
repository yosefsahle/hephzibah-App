import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/presentation/providers/post_provider.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';
import 'package:hephzibah/features/posts/presentation/widgets/post_card.dart';

class PostListView extends ConsumerWidget {
  final String? search;
  final String? postType;

  const PostListView({Key? key, this.search, this.postType}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(
      postListProvider((search: search, postType: postType)),
    );

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(child: Text("No posts found."));
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading posts: $e")),
    );
  }
}
