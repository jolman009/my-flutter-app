import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Note({
    this.isarId = Isar.autoIncrement,
    required this.id,
    required this.title,
    required this.body,
    this.colorValue,
    this.tag,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Id isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  late String body;
  int? colorValue;
  String? tag;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSynced;

  Note copyWith({
    String? title,
    String? body,
    int? colorValue,
    bool clearColor = false,
    String? tag,
    bool clearTag = false,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Note(
      isarId: isarId,
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      colorValue: clearColor ? null : (colorValue ?? this.colorValue),
      tag: clearTag ? null : (tag ?? this.tag),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

