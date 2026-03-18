import 'package:flutter/material.dart';

class NoteFilterBar extends StatelessWidget {
  const NoteFilterBar({
    super.key,
    required this.searchQuery,
    required this.tags,
    required this.selectedTag,
    required this.onSearchChanged,
    required this.onTagSelected,
  });

  final String searchQuery;
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTagSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: searchQuery,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search notes',
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedTag == null,
                onSelected: (_) => onTagSelected(null),
              ),
              const SizedBox(width: 8),
              ...tags.map(
                (tag) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tag),
                    selected: selectedTag == tag,
                    onSelected: (_) => onTagSelected(tag),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
