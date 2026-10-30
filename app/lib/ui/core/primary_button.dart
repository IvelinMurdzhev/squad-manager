import 'package:flutter/material.dart';

import '../../config/theme/tokens.dart';

enum PrimaryButtonStyle {
  /// Forest green on light backgrounds.
  green,

  /// Gold on the green Welcome background.
  gold,
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.style = PrimaryButtonStyle.green,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final PrimaryButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (style) {
      PrimaryButtonStyle.green => (AppColors.primary, AppColors.cream),
      PrimaryButtonStyle.gold => (AppColors.gold, AppColors.primary),
    };
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.buttonLarge),
        ),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(label),
    );
  }
}
