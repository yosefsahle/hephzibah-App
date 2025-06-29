import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/token_storage.dart';
import '../../data/auth_api_service.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/user_model.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authApiProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      final api = ref.read(authApiProvider);
      final tokenStorage = ref.read(tokenStorageProvider);
      return AuthNotifier(api, tokenStorage);
    });

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthApiService _api;
  final TokenStorage _tokenStorage;

  String? _accessToken;

  AuthNotifier(this._api, this._tokenStorage)
    : super(const AsyncValue.loading()) {
    _autoLogin();
  }

  String? get token => _accessToken;

  Future<void> _autoLogin() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        _accessToken = token;
        final user = await _api.getUserProfile(token);
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login(LoginRequestModel request) async {
    state = const AsyncValue.loading();
    try {
      final tokenResponse = await _api.login(request);
      _accessToken = tokenResponse.access;

      // Save tokens securely
      await _tokenStorage.saveTokens(
        access: tokenResponse.access,
        refresh: tokenResponse.refresh,
      );

      final user = await _api.getUserProfile(_accessToken!);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    await _tokenStorage.clearTokens();
    state = const AsyncValue.data(null);
  }
}
