import 'package:flutter/material.dart';

import '../widgets/onboarding_scaffold.dart';

class LocalStorageScreen extends StatelessWidget {
  const LocalStorageScreen({super.key, required this.onNext, this.onBack});

  final VoidCallback onNext;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OnboardingScaffold(
      stepIndex: 1,
      stepCount: 6,
      primaryLabel: 'Continue',
      onPrimary: onNext,
      onBack: onBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smartphone_rounded, size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text('Your notes stay on your phone', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            'Noto saves your notes locally in a folder you choose. '
            'You remain in control of where your notes are stored.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: theme.colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Moving or deleting that folder can affect access to your '
                    'notes, so choose a place you trust.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
