abstract class NotesAiService {
  Future<String> summarizeNote(String title, String body);
}

abstract class HabitsSuggestionService {
  Future<List<String>> suggestHabits({
    required List<String> existingHabits,
  });
}

