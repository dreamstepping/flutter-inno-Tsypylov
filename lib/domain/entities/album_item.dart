import 'package:flutter/material.dart';

enum AlbumCategory {
  electronic,
  metal,
  rock,
}

class AlbumItem {
  final String id; 
  final String title;
  final String artist;
  final String genre;
  final AlbumCategory category;
  final IconData categoryIcon;
  final Color backgroundColor;
  final String? description;
  const AlbumItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.category,
    required this.categoryIcon,
    required this.backgroundColor,
    this.description,
  });

  
  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    final iconMap = {
      'electronic': Icons.bug_report,
      'metal': Icons.star,
      'rock': Icons.loop,
    };

    final categoryStr = (json['category'] as String?) ?? 'rock';

    final colorStr = (json['backgroundColor'] as String?) ?? '7F8C8D';

    return AlbumItem(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? 'Без названия', 
      artist: (json['artist'] as String?) ?? 'Неизвестный исполнитель', 
      genre: (json['genre'] as String?) ?? 'Разное', 
      category: AlbumCategory.values.byName(categoryStr),
      categoryIcon: iconMap[categoryStr] ?? Icons.music_note,
      backgroundColor: Color(int.parse('FF$colorStr', radix: 16)),
      description: json['description'] as String?, 
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'genre': genre,
      'category': category.name,
      'backgroundColor': backgroundColor.toARGB32().toRadixString(16).substring(2).toUpperCase(),
      'description': description ?? '',
    };
  }
}
