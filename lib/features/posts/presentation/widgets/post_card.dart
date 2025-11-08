import 'package:flutter/material.dart';
import 'package:hephzibah/features/posts/domain/models/post_media_model.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (post.description != null && post.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(post.description!),
              ),

            // Media section
            if (post.media.isNotEmpty) _buildMediaGrid(context),

            const SizedBox(height: 8),

            // Interactions row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${post.likeCount} Likes'),
                Text('${post.comments.length} Comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGrid(BuildContext context) {
    final media = post.media;

    if (media.length == 1) {
      return _buildSingleMedia(media.first);
    }

    return GridView.builder(
      itemCount: media.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        return _buildMediaItem(media[index]);
      },
    );
  }

  Widget _buildSingleMedia(PostMediaModel media) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _buildMediaItem(media),
    );
  }

  Widget _buildMediaItem(PostMediaModel media) {
    switch (media.mediaType) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            media.file ?? media.externalLink ?? '',
            fit: BoxFit.cover,
            height: 180,
            width: double.infinity,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 80),
          ),
        );

      case 'video':
        return _VideoPlayerPreview(url: media.file ?? '');

      case 'audio':
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.audiotrack, size: 48),
            Text(media.file?.split('/').last ?? 'Audio'),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}

class _VideoPlayerPreview extends StatefulWidget {
  final String url;
  const _VideoPlayerPreview({required this.url});

  @override
  State<_VideoPlayerPreview> createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<_VideoPlayerPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
