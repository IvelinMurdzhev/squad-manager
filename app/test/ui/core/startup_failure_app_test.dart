import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/l10n/generated/app_localizations_bg.dart';
import 'package:squad_manager/ui/core/startup_failure_app.dart';

void main() {
  testWidgets('shows the localized startup failure message', (tester) async {
    await tester.pumpWidget(const StartupFailureApp());
    await tester.pumpAndSettle();

    final l10n = AppLocalizationsBg();
    expect(find.text(l10n.startupFailureTitle), findsOneWidget);
    expect(find.text(l10n.startupFailureBody), findsOneWidget);
  });
}
