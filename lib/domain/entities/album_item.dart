import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Чтение напрямую из документа Firestore (исправляет ошибку fromFirestore)
  factory AlbumItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final iconMap = {
      'electronic': Icons.bug_report,
      'metal': Icons.star,
      'rock': Icons.loop,
    };

    final categoryStr = data['category'] as String? ?? 'rock';
    final colorStr = data['backgroundColor'] as String? ?? '7F8C8D';

    return AlbumItem(
      id: doc.id,
      title: data['title'] as String? ?? 'Без названия',
      artist: data['artist'] as String? ?? 'Неизвестный исполнитель',
      genre: data['genre'] as String? ?? 'Разное',
      category: AlbumCategory.values.byName(categoryStr),
      categoryIcon: iconMap[categoryStr] ?? Icons.music_note,
      backgroundColor: Color(int.parse('FF$colorStr', radix: 16)),
      description: data['description'] as String?,
    );
  }

  // Для отправки данных в Firestore
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
