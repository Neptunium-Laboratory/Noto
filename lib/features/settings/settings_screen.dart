import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/note.dart';
import '../../core/services/settings_controller.dart';
import '../../widgets/noto_logo.dart';
import 'widgets/theme_picker_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final settings = settingsController.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(settings.themeMode.label),
            onTap: () => showThemePickerSheet(
              context,
              current: settings.themeMode,
              onSelect: (mode) => settingsController.setThemeMode(mode),
            ),
          ),
          const Divider(height: 1),
          _SectionHeader('Storage'),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Notes folder'),
            subtitle: Text(
              settings.hasStorageFolder
                  ? (settingsController.folderMissing
                      ? '${settings.storageFolderName} — not found'
                      : settings.storageFolderName ?? '')
                  : 'Not set',
            ),
            trailing: settingsController.folderMissing
                ? Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error)
                : null,
            onTap: () => _changeFolder(context, settingsController),
          ),
          if (settingsController.folderMissing)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                "Noto can't find this folder anymore. It may have been moved, "
                'deleted, or is on storage that isn\'t connected. Choose a new '
                'folder to keep saving notes — your other settings are safe.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const Divider(height: 1),
          _SectionHeader('Notes'),
          SwitchListTile(
            secondary: const Icon(Icons.save_outlined),
            title: const Text('Autosave'),
            subtitle: const Text('Save changes automatically while you type'),
            value: settings.autosaveEnabled,
            onChanged: settingsController.setAutosaveEnabled,
          ),
          ListTile(
            leading: const Icon(Icons.sort_rounded),
            title: const Text('Sort notes by'),
            subtitle: Text(settings.sortOrder.label),
            onTap: () => _showSortSheet(context, settingsController),
          ),
          const Divider(height: 1),
          _SectionHeader('Security'),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline_rounded),
            title: const Text('App lock'),
            subtitle: const Text('Require PIN or biometrics to open Noto'),
            value: settings.appLockEnabled,
            onChanged: settingsController.setAppLockEnabled,
          ),
          const Divider(height: 1),
          _SectionHeader('About'),
          const ListTile(
            leading: Padding(
              padding: EdgeInsets.all(4),
              child: NotoLogo(size: 32),
            ),
            title: Text('Noto by Neptunium'),
            subtitle: Text('Version 0.1.0'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _changeFolder(BuildContext context, SettingsController controller) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create_new_folder_outlined),
              title: const Text('Create a new Noto folder'),
              onTap: () => Navigator.pop(ctx, 'create'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: const Text('Choose an existing folder'),
              onTap: () => Navigator.pop(ctx, 'choose'),
            ),
          ],
        ),
      ),
    );

    if (choice == 'create') {
      await controller.createDefaultFolder();
    } else if (choice == 'choose') {
      await controller.pickExistingFolder();
    }
  }

  Future<void> _showSortSheet(BuildContext context, SettingsController controller) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final order in NoteSortOrder.values)
              RadioListTile<NoteSortOrder>(
                value: order,
                groupValue: controller.settings.sortOrder,
                title: Text(order.label),
                onChanged: (value) {
                  if (value != null) controller.setSortOrder(value);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
