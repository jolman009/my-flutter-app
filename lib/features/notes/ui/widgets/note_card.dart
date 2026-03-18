import 'package:flutter/material.dart';

import '../../data/models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        note.colorValue != null ? Color(note.colorValue!) : Colors.white;

    return Card(
      color: backgroundColor,
      child: ListTile(
        onTap: onTap,
        title: Text(note.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Text(
              note.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if ((note.tag ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Chip(label: Text(note.tag!)),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

