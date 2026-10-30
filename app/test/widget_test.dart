import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/app.dart';
import 'package:squad_manager/l10n/generated/app_localizations_bg.dart';
import 'package:squad_manager/routing/auth_state.dart';

void main() {
  final l10n = AppLocalizationsBg();

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(SquadManagerApp(authState: StubAuthState()));
    await tester.pumpAndSettle();
  }

  testWidgets('app starts on the Welcome screen when signed out', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.text(l10n.appTagline), findsOneWidget);
    expect(find.text(l10n.introMatchesTitle), findsOneWidget);
  });

  testWidgets('Sign in opens the sign-in placeholder', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(FilledButton, l10n.signIn));
    await tester.pumpAndSettle();

    expect(find.text(l10n.placeholderComingSoon), findsOneWidget);
  });

  testWidgets('Contact us opens the contacts placeholder', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(l10n.contactUs));
    await tester.pumpAndSettle();

    expect(find.text(l10n.contacts), findsOneWidget);
    expect(find.text(l10n.placeholderComingSoon), findsOneWidget);
  });
}
