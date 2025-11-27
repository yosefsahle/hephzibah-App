// features/posts/presentation/pages/post_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/presentation/providers/post_provider.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends ConsumerWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(postId));

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: postAsync.when(
        data: (post) => SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (post.media.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.media.length,
                    itemBuilder: (context, index) {
                      final media = post.media[index];
                      // Simple image preview for images, can expand for video, etc.
                      // if (media.mediaType == 'image') {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(right: 8.0),
                      //     child: Image.network(media?.file, fit: BoxFit.cover),
                      //   );
                      // } else {
                      //   return Container(
                      //     width: 150,
                      //     color: Colors.grey.shade300,
                      //     child: Center(
                      //       child: Text(media.mediaType.toUpperCase()),
                      //     ),
                      //   );
                      // }
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Text(post.description ?? ''),
              const SizedBox(height: 12),
              Text(post.contentText ?? ''),
              // Add more post details here (comments, interactions etc)
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading post: $e')),
      ),
    );
  }
}
