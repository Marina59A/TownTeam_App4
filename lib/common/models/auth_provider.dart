import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/favorites_provider.dart';

class AuthProvider with ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoggedIn = false;
  String? _userId;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((firebase_auth.User? user) async {
      if (user != null) {
        _isLoggedIn = true;
        _userId = user.uid;
        _userEmail = user.email;

        // Fetch user data from Firestore
        try {
          final doc = await _firestore.collection('users').doc(user.uid).get();
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            _userName = data['name'] as String?;
          }
        } catch (e) {
          print('Error fetching user data: $e');
        }
      } else {
        _isLoggedIn = false;
        _userId = null;
        _userName = null;
        _userEmail = null;
      }
      notifyListeners();
    });
  }

  Future<void> login(String userId, BuildContext context) async {
    _isLoggedIn = true;
    _userId = userId;

    // Initialize favorites after login
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    await favoritesProvider.loadFavorites();

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Clear favorites before logout
      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);
      favoritesProvider.clear();

      await _auth.signOut();
      _isLoggedIn = false;
      _userId = null;
      _userName = null;
      _userEmail = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
