class NotoFolder {
  final String id;
  final String name;
  final DateTime createdAt;

  const NotoFolder({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  NotoFolder copyWith({String? name}) {
    return NotoFolder(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory NotoFolder.fromJson(Map<String, dynamic> json) => NotoFolder(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
