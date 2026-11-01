import '../../domain/entities/album_item.dart';

sealed class AlbumsState {}

class AlbumsLoadInProgress extends AlbumsState {}

class AlbumsLoadSuccess extends AlbumsState {
  final List<AlbumItem> albums;
  AlbumsLoadSuccess(this.albums);
}

class AlbumsLoadFailure extends AlbumsState {
  final String message;
  AlbumsLoadFailure(this.message);
}
