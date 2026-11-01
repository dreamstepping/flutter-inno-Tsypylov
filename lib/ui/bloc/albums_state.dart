import '../../domain/entities/album_item.dart';

abstract class AlbumsState {}

class AlbumsInitial extends AlbumsState {}

class AlbumsLoadInProgress extends AlbumsState {}

class AlbumsLoadFailure extends AlbumsState {
  final String message;
  AlbumsLoadFailure(this.message);
}

class AlbumsLoadSuccess extends AlbumsState {
  final List<AlbumItem> albums;
  final List<String> favoriteIds;
  final bool showOnlyFavorites;

  AlbumsLoadSuccess({
    required this.albums,
    required this.favoriteIds,
    required this.showOnlyFavorites,
  });

  List<AlbumItem> get displayedAlbums {
    if (showOnlyFavorites) {
      return albums.where((album) => favoriteIds.contains(album.id)).toList();
    }
    return albums;
  }

  AlbumsLoadSuccess copyWith({
    List<AlbumItem>? albums,
    List<String>? favoriteIds,
    bool? showOnlyFavorites,
  }) {
    return AlbumsLoadSuccess(
      albums: albums ?? this.albums,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
    );
  }
}
