import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Музыкальный Каталог',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

class AlbumItem {
  final String title;
  final String artist;
  final String genre;
  final IconData categoryIcon;
  final Color backgroundColor;

  const AlbumItem({
    required this.title,
    required this.artist,
    required this.genre,
    required this.categoryIcon,
    required this.backgroundColor,
  });
}

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const List<AlbumItem> albums = [
    AlbumItem(
      title: 'The Fat of the Land',
      artist: 'The Prodigy',
      genre: 'Big Beat / Electronic Rock',
      categoryIcon: Icons.bug_report,
      backgroundColor: Color(0xFFD35400),
    ),
    AlbumItem(
      title: 'Music for the Jilted Generation',
      artist: 'The Prodigy',
      genre: 'Breakbeat / Techno',
      categoryIcon: Icons.album,
      backgroundColor: Color(0xFF2C3E50),
    ),
    AlbumItem(
      title: 'Invaders Must Die',
      artist: 'The Prodigy',
      genre: 'Synth-Punk / Dance-Rock',
      categoryIcon: Icons.dangerous,
      backgroundColor: Color(0xFFC0392B),
    ),
    AlbumItem(
      title: 'Experience',
      artist: 'The Prodigy',
      genre: 'Hardcore Rave / Breakbeat',
      categoryIcon: Icons.flash_on,
      backgroundColor: Color(0xFF27AE60),
    ),
    AlbumItem(
      title: 'Chocolate Starfish and the Hot Dog Flavored Water',
      artist: 'Limp Bizkit',
      genre: 'Nu Metal / Rap Metal',
      categoryIcon: Icons.star,
      backgroundColor: Color(0xFF922B21),
    ),
    AlbumItem(
      title: 'Significant Other',
      artist: 'Limp Bizkit',
      genre: 'Nu Metal / Rap Metal',
      categoryIcon: Icons.music_note,
      backgroundColor: Color(0xFF78281F),
    ),
    AlbumItem(
      title: 'Sinner',
      artist: 'Drowning Pool',
      genre: 'Nu Metal / Post-Grunge',
      categoryIcon: Icons.water_drop,
      backgroundColor: Color(0xFF16A085),
    ),
    AlbumItem(
      title: 'Desensitized',
      artist: 'Drowning Pool',
      genre: 'Alternative Metal',
      categoryIcon: Icons.star_purple500,
      backgroundColor: Color(0xFF8E44AD),
    ),
    AlbumItem(
      title: 'Full Circle',
      artist: 'Drowning Pool',
      genre: 'Hard Rock / Nu Metal',
      categoryIcon: Icons.loop,
      backgroundColor: Color(0xFF7F8C8D),
    ),
    AlbumItem(
      title: 'Resilience',
      artist: 'Drowning Pool',
      genre: 'Alternative Metal',
      categoryIcon: Icons.shield,
      backgroundColor: Color(0xFF212121),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Каталог музыкальных альбомов',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
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
                            album.title.substring(0, 1),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          album.artist,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          album.genre,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
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
        },
      ),
    );
  }
}
