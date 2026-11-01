import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlbumItem {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final IconData categoryIcon;
  final Color backgroundColor;
  final String description;

  const AlbumItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.categoryIcon,
    required this.backgroundColor,
    this.description = 'Легендарный трек из коллекции ДЗ 2.',
  });

  factory AlbumItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AlbumItem(
      id: doc.id,
      title: data['title'] ?? '',
      artist: data['artist'] ?? '',
      genre: data['genre'] ?? '',
      categoryIcon: IconData(data['categoryIcon'] ?? 60219, fontFamily: 'MaterialIcons'),
      backgroundColor: Color(data['backgroundColor'] ?? 4280332574),
      description: data['description'] ?? 'Легендарный трек из коллекции ДЗ 2.',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'genre': genre,
      'categoryIcon': categoryIcon.codePoint,
      // ignore: deprecated_member_use
      'backgroundColor': backgroundColor.value,
      'description': description,
    };
  }
}
