enum WorkspaceType {
  personal,
  work,
  both;

  String get label {
    switch (this) {
      case WorkspaceType.personal:
        return 'Personal productivity';
      case WorkspaceType.work:
        return 'Work projects';
      case WorkspaceType.both:
        return 'Both';
    }
  }

  String get description {
    switch (this) {
      case WorkspaceType.personal:
        return 'Journaling, to-dos, and everyday notes';
      case WorkspaceType.work:
        return 'Projects, meetings, and shared context';
      case WorkspaceType.both:
        return "A mix of personal and work — we'll keep it flexible";
    }
  }

  static WorkspaceType fromStorageKey(String? key) {
    return WorkspaceType.values.firstWhere(
      (t) => t.name == key,
      orElse: () => WorkspaceType.both,
    );
  }
}
