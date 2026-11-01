import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/album_item.dart';
import 'albums_event.dart';
import 'albums_state.dart';

class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  AlbumsBloc() : super(AlbumsLoadInProgress()) {
    on<AlbumsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    AlbumsLoadRequested event,
    Emitter<AlbumsState> emit,
  ) async {
    emit(AlbumsLoadInProgress());

    
    await emit.forEach<QuerySnapshot<Map<String, dynamic>>>(
      FirebaseFirestore.instance
          .collection('albums')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      onData: (snapshot) {
        final albums = snapshot.docs
            .map((doc) => AlbumItem.fromFirestore(doc))
            .toList();
        return AlbumsLoadSuccess(albums);
      },
      onError: (error, stackTrace) {
        return AlbumsLoadFailure('Не удалось загрузить каталог');
      },
    );
  }
}
