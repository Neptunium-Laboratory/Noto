import 'package:flutter/material.dart';

import '../../../widgets/noto_logo.dart';
import '../widgets/onboarding_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OnboardingScaffold(
      stepIndex: 0,
      stepCount: 6,
      primaryLabel: 'Get started',
      onPrimary: onNext,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NotoLogo(size: 96),
            const SizedBox(height: 32),
            Text(
              'Your organized productivity workspace',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Capture ideas, organize your work, and keep your notes '
              'safely on your device.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Noto by Neptunium',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
