import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/entities/album_item.dart';
import 'albums_event.dart';
import 'albums_state.dart';

class _AlbumsUpdated extends AlbumsEvent {
  final List<AlbumItem> albums;
  final List<String> favoriteIds;
  _AlbumsUpdated({required this.albums, required this.favoriteIds});
}

class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  final CatalogRepository repository;
  StreamSubscription? _albumsSubscription;
  StreamSubscription? _favoritesSubscription;

  List<AlbumItem> _lastAlbums = [];
  List<String> _lastFavorites = [];

  final List<AlbumItem> _localBackup = const [
    AlbumItem(id: 'p1', title: 'The Fat of the Land', artist: 'The Prodigy', genre: 'Big Beat / Electronic Rock', categoryIcon: Icons.bug_report, backgroundColor: Color(0xFFD35400)),
    AlbumItem(id: 'p2', title: 'Music for the Jilted Generation', artist: 'The Prodigy', genre: 'Breakbeat / Techno', categoryIcon: Icons.album, backgroundColor: Color(0xFF2C3E50)),
    AlbumItem(id: 'p3', title: 'Invaders Must Die', artist: 'The Prodigy', genre: 'Synth-Punk / Dance-Rock', categoryIcon: Icons.dangerous, backgroundColor: Color(0xFFC0392B)),
    AlbumItem(id: 'p4', title: 'Experience', artist: 'The Prodigy', genre: 'Hardcore Rave / Breakbeat', categoryIcon: Icons.flash_on, backgroundColor: Color(0xFF27AE60)),
    AlbumItem(id: 'l1', title: 'Chocolate Starfish...', artist: 'Limp Bizkit', genre: 'Nu Metal / Rap Metal', categoryIcon: Icons.star, backgroundColor: Color(0xFF922B21)),
    AlbumItem(id: 'l2', title: 'Significant Other', artist: 'Limp Bizkit', genre: 'Nu Metal / Rap Metal', categoryIcon: Icons.music_note, backgroundColor: Color(0xFF78281F)),
    AlbumItem(id: 'd1', title: 'Sinner', artist: 'Drowning Pool', genre: 'Nu Metal / Post-Grunge', categoryIcon: Icons.water_drop, backgroundColor: Color(0xFF16A085)),
    AlbumItem(id: 'd2', title: 'Desensitized', artist: 'Drowning Pool', genre: 'Alternative Metal', categoryIcon: Icons.star_purple500, backgroundColor: Color(0xFF8E44AD)),
    AlbumItem(id: 'd3', title: 'Full Circle', artist: 'Drowning Pool', genre: 'Hard Rock / Nu Metal', categoryIcon: Icons.loop, backgroundColor: Color(0xFF7F8C8D)),
    AlbumItem(id: 'd4', title: 'Resilience', artist: 'Drowning Pool', genre: 'Alternative Metal', categoryIcon: Icons.shield, backgroundColor: Color(0xFF212121)),
  ];

  AlbumsBloc(this.repository) : super(AlbumsLoadInProgress()) {
    on<AlbumsLoadRequested>(_onLoadRequested);
    on<_AlbumsUpdated>(_onAlbumsUpdated);
    on<ToggleLikeRequested>(_onToggleLikeRequested);
    on<ToggleFilterRequested>(_onToggleFilterRequested);
    on<AlbumAdded>(_onAlbumAdded);
  }

  void _onLoadRequested(AlbumsLoadRequested event, Emitter<AlbumsState> emit) {
    emit(AlbumsLoadInProgress());
    
    _albumsSubscription?.cancel();
    _favoritesSubscription?.cancel();

    
    _albumsSubscription = repository.albumsStream().listen(
      (albums) {
        _lastAlbums = albums;
        add(_AlbumsUpdated(albums: _lastAlbums, favoriteIds: _lastFavorites));
      },
      onError: (_) {
        add(_AlbumsUpdated(albums: _localBackup, favoriteIds: _lastFavorites));
      },
    );

    _favoritesSubscription = repository.favoritesStream(event.uid).listen(
      (favorites) {
        _lastFavorites = favorites;
        add(_AlbumsUpdated(albums: _lastAlbums, favoriteIds: _lastFavorites));
      },
      onError: (_) {
        add(_AlbumsUpdated(albums: _lastAlbums, favoriteIds: []));
      },
    );
  }

  void _onAlbumsUpdated(_AlbumsUpdated event, Emitter<AlbumsState> emit) {
    final bool currentFilter = state is AlbumsLoadSuccess ? (state as AlbumsLoadSuccess).showOnlyFavorites : false;
    
    // Если из Firestore стрим пришел пустой, подставляем элементы ДЗ 2
    final List<AlbumItem> finalAlbums = event.albums.isEmpty ? _localBackup : event.albums;

    emit(AlbumsLoadSuccess(
      albums: finalAlbums,
      favoriteIds: event.favoriteIds,
      showOnlyFavorites: currentFilter,
    ));
  }

  Future<void> _onToggleLikeRequested(ToggleLikeRequested event, Emitter<AlbumsState> emit) async {
    if (state is AlbumsLoadSuccess) {
      final currentState = state as AlbumsLoadSuccess;
      final isLiked = currentState.favoriteIds.contains(event.itemId);
      try {
        await repository.toggleLike(event.uid, event.itemId, !isLiked);
      } catch (_) {}
    }
  }

  void _onToggleFilterRequested(ToggleFilterRequested event, Emitter<AlbumsState> emit) {
    if (state is AlbumsLoadSuccess) {
      final currentState = state as AlbumsLoadSuccess;
      emit(currentState.copyWith(showOnlyFavorites: !currentState.showOnlyFavorites));
    }
  }

    Future<void> _onAlbumAdded(AlbumAdded event, Emitter<AlbumsState> emit) async {
    
    try {
      await repository.addAlbum(event.album);
    } catch (_) {}

    
    if (state is AlbumsLoadSuccess) {
      final currentState = state as AlbumsLoadSuccess;
      
      // Создаем копию добавляемого альбома с уникальным ID, чтобы работали лайки
      final newAlbumWithId = AlbumItem(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        title: event.album.title,
        artist: event.album.artist,
        genre: event.album.genre,
        categoryIcon: event.album.categoryIcon,
        backgroundColor: event.album.backgroundColor,
        description: event.album.description,
      );

      
      final updatedAlbums = List<AlbumItem>.from(currentState.albums)..add(newAlbumWithId);
      
      
      emit(currentState.copyWith(albums: updatedAlbums));
    }
  }


  @override
  Future<void> close() {
    _albumsSubscription?.cancel();
    _favoritesSubscription?.cancel();
    return super.close();
  }
}
