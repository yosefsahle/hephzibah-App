// lib/features/auth/presentation/pages/send_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SendOtpScreen extends ConsumerStatefulWidget {
  final bool isRegistration;

  const SendOtpScreen({super.key, required this.isRegistration});

  @override
  ConsumerState<SendOtpScreen> createState() => _SendOtpScreenState();
}

class _SendOtpScreenState extends ConsumerState<SendOtpScreen> {
  final _phoneController = TextEditingController();

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your phone number',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    try {
      if (widget.isRegistration) {
        await ref.read(authStateProvider.notifier).sendRegistrationOtp(phone);
      } else {
        await ref.read(authStateProvider.notifier).sendPasswordResetOtp(phone);
      }

      // Navigate to OTP verification screen
      context.push(
        '/verify-otp',
        extra: {'phone': phone, 'isRegistration': widget.isRegistration},
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;
    final colors = Theme.of(context).colorScheme;
    final fontsize = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/icons/signup.svg', width: 180),
                const SizedBox(height: 20),
                Text(
                  widget.isRegistration ? 'Register' : 'Forget Password',
                  style: fontsize.displayMedium,
                ),
                Text(
                  widget.isRegistration
                      ? 'Create Your Hephzibah!'
                      : 'Reset Your Password',
                  style: TextStyle(color: colors.outline.withOpacity(0.5)),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            55,
                          ), // Sets minimum width to 150 and height to 40
                        ),
                        onPressed: _sendOtp,
                        child: const Text('Send OTP'),
                      ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    context.goNamed('login');
                  },
                  child: const Text(
                    'Already have an account?  Login',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return const SendOtpScreen(isRegistration: false);
                        },
                      ),
                    );
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
