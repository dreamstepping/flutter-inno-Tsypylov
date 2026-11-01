import 'package:flutter/material.dart';
import '../../domain/entities/album_item.dart';

class AlbumCard extends StatelessWidget {
  final AlbumItem album;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const AlbumCard({
    super.key,
    required this.album,
    required this.isLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 95,
              height: 95,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: album.backgroundColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      album.title.isNotEmpty ? album.title.substring(0, 1) : '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onLikeTap,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    album.artist,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.orange),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    album.genre,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(album.categoryIcon, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      const Text(
                        'Стиль',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
