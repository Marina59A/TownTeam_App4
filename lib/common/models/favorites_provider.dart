import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:townteam_app/common/models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _favoriteProductIds = [];
  bool _isLoading = false;

  List<String> get favoriteProductIds => _favoriteProductIds;
  bool get isLoading => _isLoading;

  // Initialize favorites when user logs in
  void initialize() {
    if (_auth.currentUser != null) {
      loadFavorites();
    }
  }

  Future<void> loadFavorites() async {
    if (_auth.currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .get();

      _favoriteProductIds = snapshot.docs.map((doc) => doc.id).toList();

      _isLoading = false;
      notifyListeners();

      log('Loaded favorites: $_favoriteProductIds');
    } catch (e) {
      _isLoading = false;
      log('Error loading favorites: $e');
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(
    String productId, {
    Product? product,
    String? collectionPath,
    String? documentPath,
    String? subcollectionPath,
  }) async {
    if (_auth.currentUser == null) return;

    try {
      final userFavoritesRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favorites')
          .doc(productId);

      final bool isCurrentlyFavorite = _favoriteProductIds.contains(productId);

      if (isCurrentlyFavorite) {
        // Remove from favorites
        await userFavoritesRef.delete();
        _favoriteProductIds.remove(productId);
      } else {
        // Add to favorites
        if (product != null) {
          await userFavoritesRef.set({
            'timestamp': FieldValue.serverTimestamp(),
            'productId': productId,
            'name': product.name,
            'price': product.discountedPrice,
            'originalPrice': product.originalPrice,
            'imageUrl': product.imageUrl,
            'category': product.category,
            'collectionPath': collectionPath,
            'documentPath': documentPath,
            'subcollectionPath': subcollectionPath,
            'title': product.name,
            'image': {
              'src': product.imageUrl.startsWith('https:')
                  ? product.imageUrl.substring(6)
                  : product.imageUrl
            }
          });
        }
        _favoriteProductIds.add(productId);
      }

      log('Toggled favorite for product $productId. Is favorite: ${!isCurrentlyFavorite}');
      notifyListeners();
    } catch (e) {
      log('Error toggling favorite: $e');
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  // Clear favorites when user logs out
  void clear() {
    _favoriteProductIds = [];
    notifyListeners();
  }
}
