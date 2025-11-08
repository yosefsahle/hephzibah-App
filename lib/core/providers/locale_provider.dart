import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/locale_service.dart';

// Async provider to load on app start
final asyncLocaleProvider = FutureProvider<Locale>((ref) async {
  return await LocaleService.loadLocale();
});

// Actual state provider (can be overridden)
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
