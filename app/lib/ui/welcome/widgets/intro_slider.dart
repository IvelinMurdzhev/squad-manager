import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme/tokens.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../welcome_view_model.dart';

class _Slide {
  const _Slide(this.icon, this.title, this.body);

  final IconData icon;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;
}

final List<_Slide> _slides = [
  _Slide(
    Icons.calendar_today_outlined,
    (l) => l.introMatchesTitle,
    (l) => l.introMatchesBody,
  ),
  _Slide(
    Icons.check_rounded,
    (l) => l.introAttendanceTitle,
    (l) => l.introAttendanceBody,
  ),
  _Slide(
    Icons.sports_soccer_outlined,
    (l) => l.introLineupTitle,
    (l) => l.introLineupBody,
  ),
  _Slide(
    Icons.notifications_none_rounded,
    (l) => l.introRemindersTitle,
    (l) => l.introRemindersBody,
  ),
];

/// Four-slide intro: swipeable card, previous/next buttons and dot indicator.
class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  static int get slideCount => _slides.length;

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  static const Duration _animation = Duration(milliseconds: 250);
  static const double _cardHeight = 250;

  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: _animation,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = context.watch<WelcomeViewModel>();
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);

    return Column(
      children: [
        SizedBox(
          height: _cardHeight * textScale,
          child: PageView.builder(
            key: const Key('introPages'),
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: viewModel.setIndex,
            itemBuilder: (context, i) => _SlideCard(slide: _slides[i]),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundButton(
              key: const Key('introPrevious'),
              icon: Icons.chevron_left_rounded,
              tooltip: l10n.introPrevious,
              onPressed: () => _goTo(viewModel.previousIndex),
            ),
            const SizedBox(width: AppSpacing.lg),
            Semantics(
              label: l10n.introSlideIndicator(
                viewModel.index + 1,
                viewModel.slideCount,
              ),
              excludeSemantics: true,
              child: Row(
                key: const Key('introDots'),
                children: [
                  for (var i = 0; i < viewModel.slideCount; i++)
                    _Dot(active: i == viewModel.index),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            _RoundButton(
              key: const Key('introNext'),
              icon: Icons.chevron_right_rounded,
              tooltip: l10n.introNext,
              onPressed: () => _goTo(viewModel.nextIndex),
            ),
          ],
        ),
      ],
    );
  }
}

class _SlideCard extends StatelessWidget {
  const _SlideCard({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.onPrimarySurface,
        borderRadius: BorderRadius.circular(AppRadii.cardLarge),
        border: Border.all(color: AppColors.onPrimaryOutline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(AppRadii.tile),
            ),
            child: Icon(slide.icon, size: 28, color: AppColors.primary),
          ),
          const Spacer(),
          Text(
            slide.title(l10n),
            style: textTheme.headlineMedium?.copyWith(color: AppColors.cream),
          ),
          const SizedBox(height: 10),
          Text(
            slide.body(l10n),
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.onPrimaryMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 22),
      color: AppColors.cream,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(AppSpacing.minTouch),
        side: BorderSide(color: AppColors.onPrimaryControl),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.gold : AppColors.onPrimaryDot,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
