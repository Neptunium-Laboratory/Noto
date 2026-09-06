import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/settings_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class ChooseFolderScreen extends StatefulWidget {
  const ChooseFolderScreen({super.key, required this.onNext, this.onBack});

  final VoidCallback onNext;
  final VoidCallback? onBack;

  @override
  State<ChooseFolderScreen> createState() => _ChooseFolderScreenState();
}

class _ChooseFolderScreenState extends State<ChooseFolderScreen> {
  bool _busy = false;

  Future<void> _createDefault() async {
    setState(() => _busy = true);
    await context.read<SettingsController>().createDefaultFolder();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _chooseExisting() async {
    setState(() => _busy = true);
    // Returns null if the user cancels the native picker or access is
    // denied — we simply stay on this screen so nothing is lost.
    await context.read<SettingsController>().pickExistingFolder();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsController>().settings;
    final hasFolder = settings.hasStorageFolder;

    return OnboardingScaffold(
      stepIndex: 2,
      stepCount: 6,
      primaryLabel: 'Use this folder',
      primaryEnabled: hasFolder && !_busy,
      onPrimary: widget.onNext,
      onBack: widget.onBack,
      secondaryLabel: hasFolder ? null : 'Choose folder later',
      onSecondary: hasFolder ? null : widget.onNext,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Choose your notes folder', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'This is where your notes will live on your device.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            _FolderOptionCard(
              icon: Icons.create_new_folder_outlined,
              title: 'Create a Noto folder',
              subtitle: 'Recommended for most people',
              onTap: _busy ? null : _createDefault,
            ),
            const SizedBox(height: 12),
            _FolderOptionCard(
              icon: Icons.folder_open_outlined,
              title: 'Choose an existing folder',
              subtitle: 'Pick a folder you already use',
              onTap: _busy ? null : _chooseExisting,
            ),
            const SizedBox(height: 20),
            if (_busy) const Center(child: CircularProgressIndicator()),
            if (hasFolder && !_busy)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: theme.colorScheme.onSecondaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settings.storageFolderName ?? '',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          Text(
                            settings.storageFolderPath ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FolderOptionCard extends StatelessWidget {
  const _FolderOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
