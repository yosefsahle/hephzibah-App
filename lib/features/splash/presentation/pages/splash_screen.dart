import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/infrastructure/auth_service.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final locale = await ref.read(asyncLocaleProvider.future);
    final themeMode = await ref.read(asyncThemeModeProvider.future);
    final isFirstTime = await ref.read(isFirstTimeProvider.future);
    final loggedIn = await AuthService.isLoggedIn();
    final refreshTOken = await AuthService.getRefreshToken();

    ref.read(localeProvider.notifier).state = locale;
    ref.read(themeModeProvider.notifier).state = themeMode;

    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay

    if (!mounted) return;

    if (isFirstTime) {
      context.goNamed('onboarding');
    } else if (loggedIn) {
      await ref.read(authStateProvider.notifier).refreshTokens(refreshTOken!);
      // ignore: use_build_context_synchronously
      context.goNamed('home');
    } else {
      context.goNamed('login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hephzibah',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
