import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/album_item.dart';

class CatalogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Stream<List<AlbumItem>> albumsStream() {
    return _firestore.collection('catalog').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AlbumItem.fromFirestore(doc)).toList();
    });
  }

  
  Stream<List<String>> favoritesStream(String uid) {
    if (uid.isEmpty) return Stream.value([]);
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data()?['favoriteIds'] == null) return [];
      return List<String>.from(doc.data()!['favoriteIds']);
    });
  }

  
  Future<void> toggleLike(String uid, String itemId, bool isLiked) async {
    if (uid.isEmpty) return;
    final docRef = _firestore.collection('users').doc(uid);
    if (isLiked) {
      await docRef.set({
        'favoriteIds': FieldValue.arrayUnion([itemId])
      }, SetOptions(merge: true));
    } else {
      await docRef.update({
        'favoriteIds': FieldValue.arrayRemove([itemId])
      });
    }
  }

  
  Future<void> addAlbum(AlbumItem album) async {
    try {
      await _firestore.collection('catalog').add({
        'title': album.title,
        'artist': album.artist,
        'genre': album.genre,
        'categoryIcon': album.categoryIcon.codePoint,
        // ignore: deprecated_member_use
        'backgroundColor': album.backgroundColor.value, // надежный инт-код цвета для вашей версии Flutter
        'description': album.description,
      });
    } catch (e) {
      debugPrint("Ошибка добавления в Firestore: $e");
    }
  }
}
