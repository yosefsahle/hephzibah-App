import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/theme_service.dart';

// Async provider to load saved theme mode at startup
final asyncThemeModeProvider = FutureProvider<ThemeMode>((ref) async {
  return await ThemeService.loadThemeMode();
});

// Actual reactive theme mode provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
