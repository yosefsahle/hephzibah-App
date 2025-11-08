// lib/features/auth/presentation/pages/send_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/auth/presentation/providers/auth_provider.dart';

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
        const SnackBar(content: Text('Please enter your phone number')),
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authStateProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isRegistration ? 'Register - Verify Phone' : 'Reset Password',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOtp,
                    child: const Text('Send OTP'),
                  ),
          ],
        ),
      ),
    );
  }
}
