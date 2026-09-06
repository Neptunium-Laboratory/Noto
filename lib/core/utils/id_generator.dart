import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Generates a short, unique, file-name-safe ID for notes, projects,
/// and folders.
String generateId() => _uuid.v4();
