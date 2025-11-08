// lib/features/auth/provider/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/auth/domain/models/logout_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/otp_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/password_reset_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/registration_request_model.dart';
import 'package:hephzibah/features/auth/domain/models/user_model.dart';

import '../../data/services/auth_service.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(); // Replace your backend URL
});

// Auth state provider
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<LoginResponse?>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthStateNotifier(authService);
    });

class AuthStateNotifier extends StateNotifier<AsyncValue<LoginResponse?>> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AsyncValue.data(null));

  Future<void> login(String phoneNumber, String password) async {
    try {
      state = const AsyncValue.loading();

      final response = await _authService.login(
        LoginRequest(phoneNumber: phoneNumber, password: password),
      );

      state = AsyncValue.data(response);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout(String token) async {
    try {
      state = const AsyncValue.loading();

      final response = await _authService.logout(LogoutRequest(refresh: token));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<OtpResponse> sendRegistrationOtp(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();
      final response = await _authService.sendOtp(
        OtpRequest(phoneNumber: phoneNumber),
        isRegistration: true,
      );
      state = const AsyncValue.data(null); // or manage state as needed
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<OtpResponse> sendPasswordResetOtp(String phoneNumber) async {
    try {
      state = const AsyncValue.loading();
      final response = await _authService.sendOtp(
        OtpRequest(phoneNumber: phoneNumber),
        isRegistration: false,
      );
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<OtpResponse> verifyOtpCode(String phoneNumber, String code) async {
    try {
      state = const AsyncValue.loading();
      final response = await _authService.verifyOtp(
        OtpVerificationRequest(phoneNumber: phoneNumber, code: code),
      );
      state = const AsyncValue.data(null);
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Inside AuthStateNotifier in auth_provider.dart

  Future<OtpResponse> resetPassword(String phone, String newPassword) async {
    try {
      state = const AsyncValue.loading();

      final result = await _authService.resetPassword(
        PasswordResetRequest(phoneNumber: phone, newPassword: newPassword),
      );

      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // In AuthStateNotifier in auth_provider.dart

  Future<UserModel> registerUser(RegistrationRequest request) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.registerUser(request);
      state = const AsyncValue.data(null);
      return user;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
