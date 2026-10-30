import 'package:flutter/material.dart';

enum AlbumCategory {
  electronic,
  metal,
  rock,
}

class AlbumItem {
  final int id; 
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
}
