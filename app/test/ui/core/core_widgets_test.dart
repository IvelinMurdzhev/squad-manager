import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squad_manager/config/theme/app_theme.dart';
import 'package:squad_manager/ui/core/crest_avatar.dart';
import 'package:squad_manager/ui/core/primary_button.dart';
import 'package:squad_manager/ui/core/segmented_choice.dart';
import 'package:squad_manager/ui/core/status_pill.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('PrimaryButton shows its label and reports taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(PrimaryButton(label: 'A', onPressed: () => taps++)),
    );

    await tester.tap(find.text('A'));
    expect(taps, 1);
  });

  testWidgets('PrimaryButton is disabled without a callback', (tester) async {
    await tester.pumpWidget(
      _host(const PrimaryButton(label: 'A', onPressed: null)),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('StatusPill shows its label for every tone', (tester) async {
    for (final tone in StatusTone.values) {
      await tester.pumpWidget(_host(StatusPill(label: tone.name, tone: tone)));
      expect(find.text(tone.name), findsOneWidget);
    }
  });

  group('CrestAvatar', () {
    test('monogram uses first and last word initials', () {
      expect(CrestAvatar.monogram('Левски София'), 'ЛС');
      expect(CrestAvatar.monogram('Лъвове'), 'Л');
      expect(CrestAvatar.monogram('  a b c '), 'AC');
      expect(CrestAvatar.monogram('   '), '');
    });

    testWidgets('falls back to the monogram without an image', (tester) async {
      await tester.pumpWidget(_host(const CrestAvatar(name: 'Test Team')));

      expect(find.text('TT'), findsOneWidget);
    });

    testWidgets('hides the monogram when an image is given', (tester) async {
      await tester.pumpWidget(
        _host(
          CrestAvatar(
            name: 'Test Team',
            image: MemoryImage(Uint8List.fromList(_transparentPixelPng)),
          ),
        ),
      );

      expect(find.text('TT'), findsNothing);
    });
  });

  testWidgets('SegmentedChoice reports the tapped option', (tester) async {
    var selected = 'a';
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => _host(
          SegmentedChoice<String>(
            options: const [
              ChoiceOption(value: 'a', label: 'One'),
              ChoiceOption(value: 'b', label: 'Two'),
            ],
            selected: selected,
            onChanged: (v) => setState(() => selected = v),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Two'));
    await tester.pump();

    expect(selected, 'b');
  });
}

const List<int> _transparentPixelPng = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];
