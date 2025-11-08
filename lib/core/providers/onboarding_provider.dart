import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/onboarding_service.dart';

final isFirstTimeProvider = FutureProvider<bool>((ref) async {
  return await OnboardingService.isFirstTime();
});
