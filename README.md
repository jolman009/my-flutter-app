# Productivity Hub

Offline-first Flutter productivity app with Tasks, Habits, and Notes.

## Stack

- Flutter
- Riverpod
- Isar

## Setup

1. Install Flutter and Dart.
2. Fetch packages:

```bash
flutter pub get
```

3. Generate Isar model code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run tests:

```bash
flutter test
```

5. Launch the app:

```bash
flutter run
```

## Structure

```text
lib/
  core/
  features/
```

Each feature is split into `ui`, `application`, and `data` to keep offline persistence, view state, and widgets isolated for future sync, auth, analytics, and AI additions.
