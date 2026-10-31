import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme/tokens.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../routing/router.dart';
import '../core/primary_button.dart';
import 'welcome_view_model.dart';
import 'widgets/intro_slider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(slideCount: IntroSlider.slideCount),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  AppSpacing.xl,
                  AppSpacing.screenEdge,
                  AppSpacing.xxl,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 104,
                          height: 104,
                          semanticLabel: l10n.logoDescription,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.appName,
                          style: textTheme.displayLarge?.copyWith(
                            color: AppColors.cream,
                            letterSpacing: 0.88,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.appTagline,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.onPrimaryMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const IntroSlider(),
                    const SizedBox(height: AppSpacing.xl),
                    Column(
                      children: [
                        PrimaryButton(
                          label: l10n.signIn,
                          style: PrimaryButtonStyle.gold,
                          onPressed: () => context.go(AppRoutes.signIn),
                        ),
                        const SizedBox(height: 14),
                        _ContactLink(
                          prompt: l10n.noAccount,
                          action: l10n.contactUs,
                          onTap: () => context.go(AppRoutes.contact),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactLink extends StatelessWidget {
  const _ContactLink({
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: AppColors.onPrimaryMuted);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('$prompt ', style: style),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.button),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.minTouch),
            child: Center(
              widthFactor: 1,
              child: Text(
                action,
                style: style?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.gold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
