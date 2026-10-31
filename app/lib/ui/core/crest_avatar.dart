import 'package:flutter/material.dart';

import '../../config/theme/tokens.dart';

/// Club or team crest. Falls back to a monogram of [name] when there is no
/// [image].
class CrestAvatar extends StatelessWidget {
  const CrestAvatar({
    required this.name,
    this.image,
    this.size = 48,
    this.ringColor = AppColors.gold,
    super.key,
  });

  final String name;
  final ImageProvider<Object>? image;
  final double size;
  final Color ringColor;

  /// Up to two initials from the first and last word of [name].
  static String monogram(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '';
    final first = words.first.characters.first;
    final last = words.length > 1 ? words.last.characters.first : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cream,
          border: Border.all(color: ringColor, width: 2),
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
        ),
        alignment: Alignment.center,
        child: image == null
            ? Text(
                monogram(name),
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: AppColors.primary, fontSize: size * 0.36),
              )
            : null,
      ),
    );
  }
}
