import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'config/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'routing/auth_state.dart';
import 'routing/router.dart';

class SquadManagerApp extends StatefulWidget {
  const SquadManagerApp({required this.authState, super.key});

  final AuthState authState;

  @override
  State<SquadManagerApp> createState() => _SquadManagerAppState();
}

class _SquadManagerAppState extends State<SquadManagerApp> {
  late final GoRouter _router = createRouter(widget.authState);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: AppTheme.light(),
      routerConfig: _router,
      locale: const Locale('bg'),
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
