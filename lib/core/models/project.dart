import 'package:flutter/material.dart';

/// A project groups notes around a goal or piece of work, independent of
/// which folder those notes physically live in. Projects and folders are
/// designed to complement each other rather than compete: a folder is
/// "where", a project is "what for".
class Project {
  final String id;
  final String name;
  final int colorValue;
  final bool archived;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
    this.archived = false,
  });

  Color get color => Color(colorValue);

  Project copyWith({String? name, int? colorValue, bool? archived}) {
    return Project(
      id: id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      archived: archived ?? this.archived,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
        'archived': archived,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        colorValue: json['colorValue'] as int,
        archived: json['archived'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// A friendly, restrained set of project colors. Not neon — meant to sit
/// quietly next to Material 3 surfaces.
const List<int> projectColorPalette = [
  0xFF3B72C4, // Noto blue
  0xFF6B9080, // sage
  0xFFB08968, // clay
  0xFF7C6A9E, // muted violet
  0xFFC9A227, // ochre
  0xFF4A7C8C, // teal
];
