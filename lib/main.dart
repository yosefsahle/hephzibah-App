import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/core/providers/locale_provider.dart';
import 'package:hephzibah/core/providers/theme_provider.dart';
import 'package:hephzibah/core/routing/app_router.dart';
import 'package:hephzibah/core/theme/app_theme.dart';
import 'package:hephzibah/l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: HephzibahApp()));
}

class HephzibahApp extends ConsumerWidget {
  const HephzibahApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider); // Your named routes router

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hephzibah',
      routerConfig: router,
      theme: AppTheme.getTheme(locale: locale, brightness: Brightness.light),
      darkTheme: AppTheme.getTheme(locale: locale, brightness: Brightness.dark),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
