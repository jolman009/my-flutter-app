import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/uuid_service.dart';
import '../data/models/note.dart';
import '../data/repositories/notes_repository.dart';

class NotesState {
  const NotesState({
    this.isLoading = false,
    this.notes = const [],
    this.searchQuery = '',
    this.selectedTag,
    this.errorMessage,
  });

  final bool isLoading;
  final List<Note> notes;
  final String searchQuery;
  final String? selectedTag;
  final String? errorMessage;

  List<String> get availableTags {
    final tags = <String>{};
    for (final note in notes) {
      final tag = note.tag?.trim();
      if (tag != null && tag.isNotEmpty) {
        tags.add(tag);
      }
    }
    final sorted = tags.toList()..sort();
    return sorted;
  }

  List<Note> get filteredNotes {
    final query = searchQuery.trim().toLowerCase();
    return notes.where((note) {
      final matchesTag = selectedTag == null || note.tag == selectedTag;
      final matchesQuery = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.body.toLowerCase().contains(query);
      return matchesTag && matchesQuery;
    }).toList();
  }

  NotesState copyWith({
    bool? isLoading,
    List<Note>? notes,
    String? searchQuery,
    String? selectedTag,
    bool clearSelectedTag = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      notes: notes ?? this.notes,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTag: clearSelectedTag ? null : (selectedTag ?? this.selectedTag),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class NotesController extends StateNotifier<NotesState> {
  NotesController({
    required NotesRepository repository,
    required UuidService uuidService,
    required AnalyticsService analyticsService,
  })  : _repository = repository,
        _uuidService = uuidService,
        _analytics = analyticsService,
        super(const NotesState());

  final NotesRepository _repository;
  final UuidService _uuidService;
  final AnalyticsService _analytics;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final notes = await _repository.getNotes();
      state = state.copyWith(isLoading: false, notes: notes);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load notes.',
      );
    }
  }

  Future<void> saveNote({
    Note? existing,
    required String title,
    required String body,
    int? colorValue,
    String? tag,
  }) async {
    final now = DateTime.now();
    final note = existing ??
        Note(
          id: _uuidService.next(),
          title: title,
          body: body,
          createdAt: now,
          updatedAt: now,
        );

    await _repository.saveNote(
      note.copyWith(
        title: title,
        body: body,
        colorValue: colorValue,
        clearColor: colorValue == null,
        tag: tag?.trim(),
        clearTag: tag?.trim().isEmpty ?? true,
        updatedAt: now,
        isSynced: false,
      ),
    );

    await _analytics.logEvent(
      existing == null ? 'note_created' : 'note_updated',
      parameters: {'note_id': note.id},
    );
    await load();
  }

  Future<void> deleteNote(String id) async {
    await _repository.deleteNote(id);
    await _analytics.logEvent('note_deleted', parameters: {'note_id': id});
    await load();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedTag(String? tag) {
    state = state.copyWith(
      selectedTag: tag,
      clearSelectedTag: tag == null,
    );
  }
}

