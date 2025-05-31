import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _favoriteProductIds = [];

  List<String> get favoriteProductIds => _favoriteProductIds;

  Future<void> loadFavorites() async {
    if (_auth.currentUser == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .get();

      _favoriteProductIds = doc.docs.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (e) {
      log('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(String productId) async {
    if (_auth.currentUser == null) return;

    try {
      final userFavoritesRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc(productId);

      if (_favoriteProductIds.contains(productId)) {
        await userFavoritesRef.delete();
        _favoriteProductIds.remove(productId);
      } else {
        await userFavoritesRef.set({'timestamp': FieldValue.serverTimestamp()});
        _favoriteProductIds.add(productId);
      }
      notifyListeners();
    } catch (e) {
      log('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }
}
