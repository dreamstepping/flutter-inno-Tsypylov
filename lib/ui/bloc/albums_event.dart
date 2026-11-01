import '../../domain/entities/album_item.dart';

abstract class AlbumsEvent {}

class AlbumsLoadRequested extends AlbumsEvent {
  final String uid;
  AlbumsLoadRequested({required this.uid});
}

class ToggleLikeRequested extends AlbumsEvent {
  final String uid;
  final String itemId;
  ToggleLikeRequested({required this.uid, required this.itemId});
}

class ToggleFilterRequested extends AlbumsEvent {}

class AlbumAdded extends AlbumsEvent {
  final AlbumItem album;
  final String uid;
  AlbumAdded({required this.album, required this.uid});
}
