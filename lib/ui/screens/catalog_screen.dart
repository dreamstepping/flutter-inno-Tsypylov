import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/album_item.dart';
import '../bloc/albums_bloc.dart';
import '../bloc/albums_event.dart';
import '../bloc/albums_state.dart';
import '../widgets/album_card.dart';
import 'details_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _showAddAlbumBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Добавить новый альбом', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Название альбома (Обязательно)',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final titleText = _titleController.text.trim();
                  if (titleText.isEmpty) return;

                  final newAlbum = AlbumItem(
                    id: '',
                    title: titleText,
                    artist: 'Independent Artist',
                    genre: 'Electronic / Rock',
                    categoryIcon: Icons.bug_report,
                    backgroundColor: const Color(0xFF2980B9),
                  );

                  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
                  context.read<AlbumsBloc>().add(AlbumAdded(album: newAlbum, uid: uid));

                  _titleController.clear();
                  Navigator.pop(bottomSheetContext);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size.fromHeight(45)),
                child: const Text('Сохранить в облако', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BlocBuilder<AlbumsBloc, AlbumsState>(
      builder: (context, state) {
        final isOnlyFavorites = state is AlbumsLoadSuccess ? state.showOnlyFavorites : false;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            title: const Text('Каталог Музыки', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            backgroundColor: Colors.orange,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _showAddAlbumBottomSheet,
              ),
              IconButton(
                icon: Icon(isOnlyFavorites ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                onPressed: () => context.read<AlbumsBloc>().add(ToggleFilterRequested()),
              ),
            ],
          ),
          body: () {
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
                      onPressed: () => context.read<AlbumsBloc>().add(AlbumsLoadRequested(uid: uid)),
                      child: const Text('Обновить'),
                    ),
                  ],
                ),
              );
            }

            if (state is AlbumsLoadSuccess) {
              final displayedAlbums = state.displayedAlbums;

              if (displayedAlbums.isEmpty) {
                return Center(
                  child: Text(
                    isOnlyFavorites ? 'В избранном пока пусто' : 'Каталог пуст',
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => context.read<AlbumsBloc>().add(AlbumsLoadRequested(uid: uid)),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                  itemCount: displayedAlbums.length,
                  itemBuilder: (context, index) {
                    final album = displayedAlbums[index];
                    final isLiked = state.favoriteIds.contains(album.id);
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(
                              album: album,
                              isLiked: isLiked,
                              onLikeTap: () {
                                context.read<AlbumsBloc>().add(ToggleLikeRequested(uid: uid, itemId: album.id));
                              },
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'album-cover-${album.id}',
                        child: AlbumCard(
                          album: album,
                          isLiked: isLiked,
                          onLikeTap: () {
                            context.read<AlbumsBloc>().add(ToggleLikeRequested(uid: uid, itemId: album.id));
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          }(),
        );
      },
    );
  }
}
