import 'package:flutter/material.dart';

import '../../../core/models/workspace_type.dart';

class WorkspaceTypeScreen extends StatelessWidget {
  const WorkspaceTypeScreen({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final WorkspaceType selected;
  final ValueChanged<WorkspaceType> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text('How will you use Noto?', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            "We'll tailor your starting content — every feature stays "
            'available either way.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          for (final type in WorkspaceType.values) ...[
            _WorkspaceCard(
              type: type,
              selected: type == selected,
              onTap: () => onSelect(type),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final WorkspaceType type;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case WorkspaceType.personal:
        return Icons.self_improvement_rounded;
      case WorkspaceType.work:
        return Icons.work_outline_rounded;
      case WorkspaceType.both:
        return Icons.dashboard_customize_outlined;
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
              Icon(_icon,
                  color: selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: selected ? scheme.onSecondaryContainer : null,
                      ),
                    ),
                    Text(
                      type.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: selected
                            ? scheme.onSecondaryContainer
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: scheme.onSecondaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
