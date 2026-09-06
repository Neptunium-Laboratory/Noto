/// A single note.
///
/// Notes are the unit of local storage: each note is persisted as its own
/// JSON file inside the user's chosen folder, so the files on disk stay
/// meaningful outside of Noto too.
///
/// `body` is stored as plain text with lightweight inline markers for
/// rich-text runs (see `lib/features/notes/rich_text_codec.dart` in a
/// full implementation). Keeping the model's on-disk shape simple here
/// keeps notes portable and human-readable.
class Note {
  final String id;
  final String title;
  final String body;
  final String? projectId;
  final String? folderId;
  final bool favorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.projectId,
    this.folderId,
    this.favorite = false,
  });

  factory Note.blank({required String id, String? folderId, String? projectId}) {
    final now = DateTime.now();
    return Note(
      id: id,
      title: '',
      body: '',
      createdAt: now,
      updatedAt: now,
      folderId: folderId,
      projectId: projectId,
    );
  }

  /// A short line used in note lists when there's no title yet.
  String get displayTitle => title.trim().isEmpty ? 'Untitled note' : title;

  String get preview {
    final firstLine = body.split('\n').firstWhere(
          (l) => l.trim().isNotEmpty,
          orElse: () => '',
        );
    return firstLine.trim();
  }

  Note copyWith({
    String? title,
    String? body,
    String? projectId,
    bool clearProjectId = false,
    String? folderId,
    bool clearFolderId = false,
    bool? favorite,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      projectId: clearProjectId ? null : (projectId ?? this.projectId),
      folderId: clearFolderId ? null : (folderId ?? this.folderId),
      favorite: favorite ?? this.favorite,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'projectId': projectId,
        'folderId': folderId,
        'favorite': favorite,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        body: json['body'] as String? ?? '',
        projectId: json['projectId'] as String?,
        folderId: json['folderId'] as String?,
        favorite: json['favorite'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

enum NoteSortOrder {
  updatedNewest,
  updatedOldest,
  titleAZ,
  createdNewest;

  String get label {
    switch (this) {
      case NoteSortOrder.updatedNewest:
        return 'Last edited';
      case NoteSortOrder.updatedOldest:
        return 'Oldest edited';
      case NoteSortOrder.titleAZ:
        return 'Title A–Z';
      case NoteSortOrder.createdNewest:
        return 'Date created';
    }
  }

  static NoteSortOrder fromStorageKey(String? key) {
    return NoteSortOrder.values.firstWhere(
      (o) => o.name == key,
      orElse: () => NoteSortOrder.updatedNewest,
    );
  }

  int Function(Note, Note) get comparator {
    switch (this) {
      case NoteSortOrder.updatedNewest:
        return (a, b) => b.updatedAt.compareTo(a.updatedAt);
      case NoteSortOrder.updatedOldest:
        return (a, b) => a.updatedAt.compareTo(b.updatedAt);
      case NoteSortOrder.titleAZ:
        return (a, b) =>
            a.displayTitle.toLowerCase().compareTo(b.displayTitle.toLowerCase());
      case NoteSortOrder.createdNewest:
        return (a, b) => b.createdAt.compareTo(a.createdAt);
    }
  }
}
