import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/data/services/media_service.dart';

/// A provider to upload media to a post
final mediaUploadProvider =
    FutureProvider.family<void, ({int postId, File file, String mediaType})>((
      ref,
      params,
    ) async {
      await MediaService.uploadMedia(
        postId: params.postId,
        file: params.file,
        mediaType: params.mediaType,
      );
    });
