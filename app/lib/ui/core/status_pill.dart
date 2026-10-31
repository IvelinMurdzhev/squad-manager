import 'package:flutter/material.dart';

import '../../config/theme/tokens.dart';

enum StatusTone { positive, maybe, negative, neutral }

/// Small rounded label for attendance and similar statuses.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.tone, super.key});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      StatusTone.positive => (AppColors.pitch, AppColors.pitch),
      StatusTone.maybe => (AppColors.gold, AppColors.ink),
      StatusTone.negative => (AppColors.terracotta, AppColors.terracottaDark),
      StatusTone.neutral => (AppColors.inkMuted, AppColors.inkMuted),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: foreground),
        ),
      ),
    );
  }
}
