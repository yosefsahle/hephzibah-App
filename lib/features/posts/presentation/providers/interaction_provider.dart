import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/posts/data/services/interaction_service.dart';

/// A provider to trigger an interaction (like, view, save, share) on a post.
final interactionProvider =
    FutureProvider.family<String, ({int postId, String type})>((
      ref,
      params,
    ) async {
      return await InteractionService.interact(
        postId: params.postId,
        type: params.type,
      );
    });
