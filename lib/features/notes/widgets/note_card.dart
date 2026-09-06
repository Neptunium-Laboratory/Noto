import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onToggleFavorite,
    this.projectColor,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final Color? projectColor;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (projectColor != null) ...[
                Container(
                  width: 4,
                  height: 40,
                  margin: const EdgeInsets.only(top: 2, right: 12),
                  decoration: BoxDecoration(
                    color: projectColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.displayTitle,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (note.preview.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.preview,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      DateFormat.MMMd().add_jm().format(note.updatedAt),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  note.favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: note.favorite ? theme.colorScheme.tertiary : theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: note.favorite ? 'Remove from favorites' : 'Add to favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
