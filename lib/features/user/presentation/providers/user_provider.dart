// features/user/presentation/provider/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/user/data/service/user_service.dart';
import '../../../auth/domain/models/user_model.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

final userProfileProvider = FutureProvider<UserModel>((ref) async {
  final service = ref.read(userServiceProvider);
  return await service.getCurrentUser();
});
