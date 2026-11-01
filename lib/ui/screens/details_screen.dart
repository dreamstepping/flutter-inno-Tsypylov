import 'package:flutter/material.dart';
import '../../domain/entities/album_item.dart';

class DetailsScreen extends StatelessWidget {
  final AlbumItem album;
  final bool isLiked;
  final VoidCallback onLikeTap;

  const DetailsScreen({
    super.key,
    required this.album,
    required this.isLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(album.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'album-cover-${album.id}',
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: album.backgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(color: album.backgroundColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      album.title.isNotEmpty ? album.title.substring(0, 1) : '?',
                      style: const TextStyle(color: Colors.white70, fontSize: 72, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(album.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(album.artist, style: const TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 32),
                  onPressed: onLikeTap,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(album.genre, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Описание', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(album.description, style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
