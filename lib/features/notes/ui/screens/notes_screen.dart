import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../application/notes_providers.dart';
import '../widgets/note_card.dart';
import '../widgets/note_filter_bar.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesControllerProvider);
    final controller = ref.read(notesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              NoteFilterBar(
                searchQuery: state.searchQuery,
                tags: state.availableTags,
                selectedTag: state.selectedTag,
                onSearchChanged: controller.setSearchQuery,
                onTagSelected: controller.setSelectedTag,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.notes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.errorMessage != null) {
                      return AppErrorView(
                        message: state.errorMessage!,
                        onRetry: controller.load,
                      );
                    }

                    if (state.filteredNotes.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.sticky_note_2_outlined,
                        title: 'No notes yet',
                        message: 'Capture ideas locally with colors and tags.',
                      );
                    }

                    return ListView.separated(
                      itemCount: state.filteredNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = state.filteredNotes[index];
                        return NoteCard(
                          note: note,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRouter.noteEditor,
                            arguments: note,
                          ),
                          onDelete: () async {
                            final confirmed = await showConfirmDeleteDialog(
                              context,
                              title: 'Delete note?',
                              message: 'This note will be removed from local storage.',
                            );
                            if (confirmed) {
                              await controller.deleteNote(note.id);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

