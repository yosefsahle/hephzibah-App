// lib/features/auth/presentation/pages/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/presentation/pages/send_otp_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter phone number and password',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    await ref.read(authStateProvider.notifier).login(phone, password);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fontsize = Theme.of(context).textTheme;
    final authState = ref.watch(authStateProvider);
    Future<void> openUrl(String url) async {
      final uri = Uri.parse(url);

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    ref.listen<AsyncValue>(authStateProvider, (previous, next) {
      next.when(
        data: (loginResponse) {
          if (loginResponse != null) {
            // Navigate to home on successful login
            context.goNamed('home');
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login failed: $error')));
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.goNamed('home');
                    },
                    child: Text("Skip", style: fontsize.headlineMedium),
                  ),
                ),
                SvgPicture.asset('assets/images/icons/login.svg', width: 180),
                const SizedBox(height: 20),
                Text('Login', style: fontsize.displayMedium),
                Text(
                  'Welcome back!',
                  style: TextStyle(color: colors.outline.withOpacity(0.5)),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                authState.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            55,
                          ), // Sets minimum width to 150 and height to 40
                        ),
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const SendOtpScreen(isRegistration: true);
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account?  Register',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    context.goNamed('register');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSocialLoginButton(
                      icon: FontAwesomeIcons.instagram,
                      onPressed: () =>
                          openUrl("https://www.instagram.com/hephzibah/"),
                    ),
                    _buildSocialLoginButton(
                      icon: FontAwesomeIcons.telegram,
                      onPressed: () => openUrl("https://t.me/hephzibah"),
                    ),
                    _buildSocialLoginButton(
                      icon: FontAwesomeIcons.facebook,
                      onPressed: () =>
                          openUrl("https://www.facebook.com/hephzibah"),
                    ),
                    _buildSocialLoginButton(
                      icon: FontAwesomeIcons.youtube,
                      onPressed: () =>
                          openUrl("https://www.youtube.com/@hephzibah"),
                    ),
                    _buildSocialLoginButton(
                      icon: FontAwesomeIcons.tiktok,
                      onPressed: () =>
                          openUrl("https://www.tiktok.com/@hephzibah"),
                    ),
                  ],
                ),
                Text(
                  'Check out our social media pages!',
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.outline.withOpacity(0.7),
                  ),
                ),
                Text(
                  '© 2025 Hephzibah. All rights reserved.',
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.outline.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      icon: FaIcon(icon, color: colors.outline.withOpacity(0.7)),
      onPressed: onPressed,
    );
  }
}
