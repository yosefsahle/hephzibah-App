// features/user/presentation/pages/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/core/theme/text_styles.dart';
import 'package:hephzibah/features/user/presentation/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: AppTextStyles.headlineSmall),
      ),
      body: profileAsync.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImage),
              ),
              const SizedBox(height: 16),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.phoneNumber),
              if (user.email != null) Text('Email: ${user.email}'),
              if (user.church != null) Text('Church: ${user.church}'),
              if (user.location != null) Text('Location: ${user.location}'),
              if (user.occupation != null)
                Text('Occupation: ${user.occupation}'),
              if (user.bio != null) Text('Bio: ${user.bio}'),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
