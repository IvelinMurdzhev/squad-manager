import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/config/theme/app_theme.dart';
import 'package:squad_manager/l10n/generated/app_localizations.dart';
import 'package:squad_manager/l10n/generated/app_localizations_bg.dart';
import 'package:squad_manager/ui/welcome/welcome_screen.dart';

Widget _host() => MaterialApp(
  theme: AppTheme.light(),
  locale: const Locale('bg'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: const WelcomeScreen(),
);

double _activeDotWidth(WidgetTester tester) {
  final dots = tester.widgetList<AnimatedContainer>(
    find.descendant(
      of: find.byKey(const Key('introDots')),
      matching: find.byType(AnimatedContainer),
    ),
  );
  return dots
      .map((d) => d.constraints?.maxWidth ?? 0)
      .reduce((a, b) => a > b ? a : b);
}

int _activeDotIndex(WidgetTester tester) {
  final dots = tester
      .widgetList<AnimatedContainer>(
        find.descendant(
          of: find.byKey(const Key('introDots')),
          matching: find.byType(AnimatedContainer),
        ),
      )
      .toList();
  return dots.indexWhere(
    (d) => d.constraints?.maxWidth == _activeDotWidth(tester),
  );
}

void main() {
  final l10n = AppLocalizationsBg();

  Future<void> pumpWelcome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_host());
    await tester.pumpAndSettle();
  }

  testWidgets('shows branding, first slide, Sign in and Contact us', (
    tester,
  ) async {
    await pumpWelcome(tester);

    expect(find.text(l10n.appName), findsOneWidget);
    expect(find.text(l10n.appTagline), findsOneWidget);
    expect(find.text(l10n.introMatchesTitle), findsOneWidget);
    expect(find.text(l10n.introMatchesBody), findsOneWidget);
    expect(find.text(l10n.signIn), findsOneWidget);
    expect(find.text('${l10n.noAccount} '), findsOneWidget);
    expect(find.text(l10n.contactUs), findsOneWidget);
  });

  testWidgets('has four dots with the first active', (tester) async {
    await pumpWelcome(tester);

    final dots = find.descendant(
      of: find.byKey(const Key('introDots')),
      matching: find.byType(AnimatedContainer),
    );
    expect(dots, findsNWidgets(4));
    expect(_activeDotIndex(tester), 0);
  });

  testWidgets('Next moves through all four slides and wraps to the first', (
    tester,
  ) async {
    await pumpWelcome(tester);
    final titles = [
      l10n.introMatchesTitle,
      l10n.introAttendanceTitle,
      l10n.introLineupTitle,
      l10n.introRemindersTitle,
    ];

    for (var i = 1; i < titles.length; i++) {
      await tester.tap(find.byKey(const Key('introNext')));
      await tester.pumpAndSettle();
      expect(find.text(titles[i]), findsOneWidget);
      expect(_activeDotIndex(tester), i);
    }

    await tester.tap(find.byKey(const Key('introNext')));
    await tester.pumpAndSettle();
    expect(find.text(titles[0]), findsOneWidget);
    expect(_activeDotIndex(tester), 0);
  });

  testWidgets('Previous on the first slide wraps to the last', (tester) async {
    await pumpWelcome(tester);

    await tester.tap(find.byKey(const Key('introPrevious')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.introRemindersTitle), findsOneWidget);
    expect(_activeDotIndex(tester), 3);
  });

  testWidgets('swiping left then right changes the slide', (tester) async {
    await pumpWelcome(tester);

    await tester.fling(
      find.byKey(const Key('introPages')),
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.introAttendanceTitle), findsOneWidget);
    expect(_activeDotIndex(tester), 1);

    await tester.fling(
      find.byKey(const Key('introPages')),
      const Offset(300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.text(l10n.introMatchesTitle), findsOneWidget);
    expect(_activeDotIndex(tester), 0);
  });

  testWidgets('slide indicator is announced to assistive technology', (
    tester,
  ) async {
    await pumpWelcome(tester);

    expect(
      find.bySemanticsLabel(l10n.introSlideIndicator(1, 4)),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('introNext')));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel(l10n.introSlideIndicator(2, 4)),
      findsOneWidget,
    );
  });
}
