import 'package:flutter/material.dart';

import '../../../core/theme/noto_theme_mode.dart';

Future<void> showThemePickerSheet(
  BuildContext context, {
  required NotoThemeMode current,
  required ValueChanged<NotoThemeMode> onSelect,
}) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Appearance', style: Theme.of(ctx).textTheme.titleMedium),
              ),
            ),
            for (final mode in NotoThemeMode.values)
              RadioListTile<NotoThemeMode>(
                value: mode,
                groupValue: current,
                title: Text(mode.label),
                subtitle: Text(mode.description),
                onChanged: (value) {
                  if (value != null) onSelect(value);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
