import 'package:uuid/uuid.dart';

class UuidService {
  const UuidService() : _uuid = const Uuid();

  final Uuid _uuid;

  String next() => _uuid.v4();
}

