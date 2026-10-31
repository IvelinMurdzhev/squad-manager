import 'package:flutter/material.dart';

import '../../config/theme/tokens.dart';

class ChoiceOption<T> {
  const ChoiceOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Single-select control with pill-shaped segments.
class SegmentedChoice<T> extends StatelessWidget {
  const SegmentedChoice({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<ChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadii.button),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            for (final option in options)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: option.value == selected,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.button - 4),
                    onTap: () => onChanged(option.value),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: AppSpacing.minTouch,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: option.value == selected
                            ? AppColors.primary
                            : null,
                        borderRadius: BorderRadius.circular(
                          AppRadii.button - 4,
                        ),
                      ),
                      child: Text(
                        option.label,
                        style: textTheme.labelMedium?.copyWith(
                          color: option.value == selected
                              ? AppColors.cream
                              : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
