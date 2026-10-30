import 'package:flutter/material.dart';
import '../../domain/entities/album_item.dart';
import '../widgets/album_card.dart';

const List<AlbumItem> _mockAlbums = [
  AlbumItem(
    id: 1,
    title: 'The Fat of the Land',
    artist: 'The Prodigy',
    genre: 'Big Beat / Electronic Rock',
    category: AlbumCategory.electronic,
    categoryIcon: Icons.bug_report,
    backgroundColor: Color(0xFFD35400),
  ),
  AlbumItem(
    id: 2,
    title: 'Music for the Jilted Generation',
    artist: 'The Prodigy',
    genre: 'Breakbeat / Techno',
    category: AlbumCategory.electronic,
    categoryIcon: Icons.album,
    backgroundColor: Color(0xFF2C3E50),
  ),
  AlbumItem(
    id: 3,
    title: 'Invaders Must Die',
    artist: 'The Prodigy',
    genre: 'Synth-Punk / Dance-Rock',
    category: AlbumCategory.electronic,
    categoryIcon: Icons.dangerous,
    backgroundColor: Color(0xFFC0392B),
  ),
  AlbumItem(
    id: 4,
    title: 'Experience',
    artist: 'The Prodigy',
    genre: 'Hardcore Rave / Breakbeat',
    category: AlbumCategory.electronic,
    categoryIcon: Icons.flash_on,
    backgroundColor: Color(0xFF27AE60),
  ),
  AlbumItem(
    id: 5,
    title: 'Chocolate Starfish...',
    artist: 'Limp Bizkit',
    genre: 'Nu Metal / Rap Metal',
    category: AlbumCategory.metal,
    categoryIcon: Icons.star,
    backgroundColor: Color(0xFF922B21),
  ),
  AlbumItem(
    id: 6,
    title: 'Significant Other',
    artist: 'Limp Bizkit',
    genre: 'Nu Metal / Rap Metal',
    category: AlbumCategory.metal,
    categoryIcon: Icons.music_note,
    backgroundColor: Color(0xFF78281F),
  ),
  AlbumItem(
    id: 7,
    title: 'Sinner',
    artist: 'Drowning Pool',
    genre: 'Nu Metal / Post-Grunge',
    category: AlbumCategory.metal,
    categoryIcon: Icons.water_drop,
    backgroundColor: Color(0xFF16A085),
  ),
  AlbumItem(
    id: 8,
    title: 'Desensitized',
    artist: 'Drowning Pool',
    genre: 'Alternative Metal',
    category: AlbumCategory.metal,
    categoryIcon: Icons.star_purple500,
    backgroundColor: Color(0xFF8E44AD),
  ),
  AlbumItem(
    id: 9,
    title: 'Full Circle',
    artist: 'Drowning Pool',
    genre: 'Hard Rock / Nu Metal',
    category: AlbumCategory.rock,
    categoryIcon: Icons.loop,
    backgroundColor: Color(0xFF7F8C8D),
  ),
  AlbumItem(
    id: 10,
    title: 'Resilience',
    artist: 'Drowning Pool',
    genre: 'Alternative Metal',
    category: AlbumCategory.metal,
    categoryIcon: Icons.shield,
    backgroundColor: Color(0xFF212121),
  ),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<int> _likedIds = {};
  
  bool _onlyFavorites = false;

  void _toggleLike(int id) {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayedAlbums = _onlyFavorites
        ? _mockAlbums.where((album) => _likedIds.contains(album.id)).toList()
        : _mockAlbums;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Музыкальный Каталог',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _onlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _onlyFavorites = !_onlyFavorites;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'В избранном: ${_likedIds.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: displayedAlbums.isEmpty
                ? const Center(
                    child: Text(
                      'Ничего не нашлось',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemCount: displayedAlbums.length,
                    itemBuilder: (context, index) {
                      final album = displayedAlbums[index];
                      return AlbumCard(
                        album: album,
                        isLiked: _likedIds.contains(album.id),
                        onLikeTap: () => _toggleLike(album.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
