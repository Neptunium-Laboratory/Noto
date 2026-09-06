import 'package:flutter/material.dart';

import '../../../core/models/app_settings.dart';
import '../../../widgets/noto_logo.dart';

class ReadyScreen extends StatelessWidget {
  const ReadyScreen({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const NotoLogo(size: 72),
          const SizedBox(height: 24),
          Text('Noto is ready', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Start with a quick note, create a project, or organize your first folder.',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.folder_outlined,
                    label: 'Storage folder',
                    value: settings.storageFolderName ?? 'Not set yet',
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    icon: Icons.dashboard_customize_outlined,
                    label: 'Workspace',
                    value: settings.workspaceType.label,
                  ),
                  const Divider(height: 24),
                  _SummaryRow(
                    icon: Icons.palette_outlined,
                    label: 'Appearance',
                    value: settings.themeMode.label,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
