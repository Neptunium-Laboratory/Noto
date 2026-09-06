import 'package:flutter/material.dart';

import '../../../core/theme/noto_theme_mode.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final NotoThemeMode selected;
  final ValueChanged<NotoThemeMode> onSelect;

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  bool _showMore = false;

  static const _primary = [
    NotoThemeMode.system,
    NotoThemeMode.light,
    NotoThemeMode.dark,
  ];

  static const _extended = [
    NotoThemeMode.catppuccinMocha,
    NotoThemeMode.system95,
  ];

  @override
  void initState() {
    super.initState();
    _showMore = _extended.contains(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('Choose your appearance', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'You can change this any time from Settings.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          for (final mode in _primary) ...[
            _ThemeTile(mode: mode, selected: widget.selected == mode, onTap: () => widget.onSelect(mode)),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () => setState(() => _showMore = !_showMore),
            icon: Icon(_showMore ? Icons.expand_less_rounded : Icons.expand_more_rounded),
            label: Text(_showMore ? 'Hide more themes' : 'More themes'),
          ),
          if (_showMore) ...[
            const SizedBox(height: 8),
            for (final mode in _extended) ...[
              _ThemeTile(mode: mode, selected: widget.selected == mode, onTap: () => widget.onSelect(mode)),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.mode, required this.selected, required this.onTap});

  final NotoThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (mode) {
      case NotoThemeMode.system:
        return Icons.brightness_auto_rounded;
      case NotoThemeMode.light:
        return Icons.light_mode_rounded;
      case NotoThemeMode.dark:
        return Icons.dark_mode_rounded;
      case NotoThemeMode.catppuccinMocha:
        return Icons.nightlight_round;
      case NotoThemeMode.system95:
        return Icons.terminal_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? scheme.primary : scheme.outlineVariant,
          width: selected ? 2 : 1,
        ),
      ),
      color: selected ? scheme.secondaryContainer : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(_icon, color: selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mode.label,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: selected ? scheme.onSecondaryContainer : null)),
                    Text(mode.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_circle_rounded, color: scheme.onSecondaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
