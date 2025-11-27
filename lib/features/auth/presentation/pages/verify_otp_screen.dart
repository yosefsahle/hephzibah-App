// lib/features/auth/presentation/pages/verify_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String phone;
  final bool isRegistration;

  const VerifyOtpScreen({
    super.key,
    required this.phone,
    required this.isRegistration,
  });

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _otpController = TextEditingController();

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP code')),
      );
      return;
    }

    try {
      await ref
          .read(authStateProvider.notifier)
          .verifyOtpCode(widget.phone, code);

      if (widget.isRegistration) {
        // Proceed to registration form (step 2)
        context.push('/register-form', extra: widget.phone);
      } else {
        // Proceed to password reset form
        context.push('/reset-password', extra: widget.phone);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;
    final colors = Theme.of(context).colorScheme;
    final fontsize = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify OTP',
          style: TextStyle(fontSize: fontsize.titleMedium?.fontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/icons/verify.svg', width: 150),
                const SizedBox(height: 20),
                Text('Verification', style: fontsize.displayMedium),
                Text(
                  widget.isRegistration
                      ? 'Verify to Start Registration'
                      : 'Verify to Reset Password',
                  style: TextStyle(color: colors.outline.withOpacity(0.5)),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP Code'),
                ),
                const SizedBox(height: 24),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            55,
                          ), // Sets minimum width to 150 and height to 40
                        ),
                        onPressed: _verifyOtp,
                        child: const Text('Verify'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
