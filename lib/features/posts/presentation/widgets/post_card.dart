import 'package:flutter/material.dart';
import 'package:hephzibah/features/posts/domain/models/post_media_model.dart';
import 'package:hephzibah/features/posts/domain/models/post_model.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool showHeart = false;
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _onDoubleTapLike() {
    if (!isLiked) {
      _toggleLike();
    }
    setState(() => showHeart = true);
    _heartController.forward(from: 0).then((_) {
      setState(() => showHeart = false);
    });
  }

  bool showFullText = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            // Description with Show More
            if (post.description != null && post.description!.isNotEmpty)
              _buildDescription(post.description!),

            const SizedBox(height: 8),

            // Media Section
            if (post.media.isNotEmpty) _buildMediaGrid(post.media),

            const SizedBox(height: 8),

            // Interactions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey[600],
                      ),
                      onPressed: _toggleLike,
                    ),
                    const SizedBox(width: 4),
                    Text('${post.likeCount + (isLiked ? 1 : 0)}'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        // Navigate to comments
                      },
                    ),
                    const SizedBox(width: 4),
                    Text('${post.comments.length}'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        // Share post
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(String text) {
    final maxLines = showFullText ? null : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: maxLines,
          overflow: showFullText ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        if (text.length > 100)
          GestureDetector(
            onTap: () => setState(() => showFullText = !showFullText),
            child: Text(
              showFullText ? 'Show Less' : 'Show More',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaGrid(List<PostMediaModel> media) {
    if (media.length == 1) return _buildSingleMedia(media.first);

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
      child: _buildMediaItem(media, isSingle: true),
    );
  }

  Widget _buildMediaItem(PostMediaModel media, {bool isSingle = false}) {
    switch (media.mediaType) {
      case 'image':
        return GestureDetector(
          onDoubleTap: _onDoubleTapLike,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  media.file ?? media.externalLink ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: isSingle ? 250 : 150,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
              if (showHeart)
                ScaleTransition(
                  scale: Tween(begin: 0.5, end: 1.5).animate(
                    CurvedAnimation(
                      parent: _heartController,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
            ],
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
      aspectRatio: _controller.value.isInitialized
          ? _controller.value.aspectRatio
          : 16 / 9,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
