import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';

class HorizontalPostCarousel extends StatelessWidget {
  final List<PostModel> posts;
  final String title;

  const HorizontalPostCarousel({
    super.key,
    required this.posts,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final post = posts[index];
              final itemWidth = MediaQuery.of(context).size.width / 2.5;

              // Get the first media URL if available
              final imageUrl = post.media.isNotEmpty
                  ? post.media.first.file
                  : null;

              return GestureDetector(
                onTap: (() {
                  context.push('/posts/${post.id}');
                  print(post.id);
                  print("This Is the post id as string");
                }),
                child: Container(
                  width: itemWidth,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
