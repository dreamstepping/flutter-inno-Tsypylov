import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/album_item.dart';
import '../bloc/albums_bloc.dart';
import '../bloc/albums_event.dart';
import '../bloc/albums_state.dart';
import '../widgets/album_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _likedIds = {};
  bool _onlyFavorites = false;
  bool _showForm = false;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _addAlbum() async {
    final titleText = _titleController.text.trim();
    if (titleText.isEmpty) return;

    try {
      final newAlbum = AlbumItem(
        id: '',
        title: titleText,
        artist: 'Unknown Artist',
        genre: 'Rock / Alternative',
        category: AlbumCategory.rock,
        categoryIcon: Icons.loop,
        backgroundColor: const Color(0xFF7F8C8D),
        description: 'Добавлено через BLoC',
      );

      final data = newAlbum.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance.collection('albums').add(data);

      setState(() {
        _titleController.clear();
        _showForm = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка добавления: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _toggleLike(String id) {
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Музыкальный Блок', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => FirebaseAuth.instance.signOut(),
        ),
        actions: [
          IconButton(
            icon: Icon(_showForm ? Icons.close : Icons.add, color: Colors.white),
            onPressed: () => setState(() => _showForm = !_showForm),
          ),
          IconButton(
            icon: Icon(_onlyFavorites ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () => setState(() => _onlyFavorites = !_onlyFavorites),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showForm) _buildFormSection(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'В избранном: ${_likedIds.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: BlocBuilder<AlbumsBloc, AlbumsState>(
              builder: (context, state) {
                // Экран загрузки (слайд 19)
                if (state is AlbumsLoadInProgress) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }

                if (state is AlbumsLoadFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<AlbumsBloc>().add(AlbumsLoadRequested()),
                          child: const Text('Обновить'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AlbumsLoadSuccess) {
                  final albums = state.albums;
                  
                  final displayedAlbums = _onlyFavorites
                      ? albums.where((album) => _likedIds.contains(album.id)).toList()
                      : albums;

                  if (displayedAlbums.isEmpty) {
                    return const Center(child: Text('Ничего не нашлось', style: TextStyle(color: Colors.grey, fontSize: 16)));
                  }

                  return RefreshIndicator(
                    onRefresh: () async => context.read<AlbumsBloc>().add(AlbumsLoadRequested()),
                    child: ListView.builder(
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
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Название нового альбома',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _addAlbum,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Отправить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
