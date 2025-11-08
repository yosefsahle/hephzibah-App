import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/presentation/pages/login_screen.dart';
import 'package:hephzibah/features/auth/presentation/pages/registration_form_screen.dart';
import 'package:hephzibah/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:hephzibah/features/auth/presentation/pages/send_otp_screen.dart';
import 'package:hephzibah/features/auth/presentation/pages/verify_otp_screen.dart';
import 'package:hephzibah/features/home/presentation/pages/home_screen.dart';
import 'package:hephzibah/features/home/presentation/pages/main_screen.dart';
import 'package:hephzibah/features/library/presentation/pages/library_page.dart';
import 'package:hephzibah/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hephzibah/features/posts/presentation/pages/post_detail_screen.dart';
import 'package:hephzibah/features/splash/presentation/pages/splash_screen.dart';
import 'package:hephzibah/features/user/presentation/pages/edit_profile_screen.dart';
import 'package:hephzibah/features/user/presentation/pages/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/send-otp',
        name: 'send-otp',
        builder: (context, state) {
          final isRegistration = state.extra as bool;
          return SendOtpScreen(isRegistration: isRegistration);
        },
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return VerifyOtpScreen(
            phone: data['phone'],
            isRegistration: data['isRegistration'],
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final phone = state.extra as String;
          return ResetPasswordScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/register-form',
        name: 'register-form',
        builder: (context, state) {
          final phone = state.extra as String;
          return RegistrationFormScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/posts/:id',
        name: 'post_detail',
        builder: (context, state) {
          final postId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return PostDetailScreen(postId: postId);
        },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const Library(),
      ),
    ],
  );
});
