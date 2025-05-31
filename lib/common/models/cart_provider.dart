import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';
import 'product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _userId;

  CartProvider([this._userId]);

  void setUserId(String userId) {
    _userId = userId;
    _loadCartFromFirebase(); // Load cart when user ID is set
  }

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + (item.product.discountedPrice * item.quantity),
    );
  }

  Future<void> _syncWithFirebase() async {
    if (_userId == null) return;

    try {
      final cartData = _items.map((key, item) => MapEntry(key, {
            'productId': item.product.id,
            'name': item.product.name,
            'price': item.product.discountedPrice,
            'originalPrice': item.product.originalPrice,
            'imageUrl': item.product.imageUrl,
            'category': item.product.category,
            'quantity': item.quantity,
          }));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc('current')
          .set({'items': cartData});
    } catch (e) {
      print('Error syncing cart with Firebase: $e');
    }
  }

  Future<void> _loadCartFromFirebase() async {
    if (_userId == null) return;

    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc('current')
          .get();

      if (cartDoc.exists && cartDoc.data() != null) {
        final cartData = cartDoc.data()!['items'] as Map<String, dynamic>;
        _items.clear();

        cartData.forEach((key, value) {
          final product = Product(
            id: value['productId'],
            name: value['name'],
            originalPrice: value['originalPrice'],
            discountedPrice: value['price'],
            imageUrl: value['imageUrl'],
            category: value['category'],
          );
          _items[key] = CartItem(
            product: product,
            quantity: value['quantity'],
          );
        });
        notifyListeners();
      }
    } catch (e) {
      print('Error loading cart from Firebase: $e');
    }
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      increaseQuantity(product);
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: 1),
      );
      notifyListeners();
      _syncWithFirebase();
    }
  }

  void increaseQuantity(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
      notifyListeners();
      _syncWithFirebase();
    }
  }

  void decreaseQuantity(Product product) {
    if (!_items.containsKey(product.id)) return;

    if (_items[product.id]!.quantity > 1) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(product.id);
    }
    notifyListeners();
    _syncWithFirebase();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    _syncWithFirebase();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _syncWithFirebase();
  }
}
