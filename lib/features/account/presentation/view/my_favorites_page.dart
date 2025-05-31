import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:townteam_app/common/models/favorites_provider.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/common/models/product.dart';
import 'package:townteam_app/common/models/auth_provider.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/product/presentaion/view/product_details_page.dart';
import 'dart:developer' as developer;

class MyFavoritesPage extends StatefulWidget {
  static const String id = 'my_favorites_page';

  const MyFavoritesPage({super.key});

  @override
  State<MyFavoritesPage> createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final favoritesProvider =
          Provider.of<FavoritesProvider>(context, listen: false);

      if (authProvider.isLoggedIn) {
        developer.log('Loading favorites for logged in user');
        favoritesProvider.loadFavorites();
      } else {
        developer.log('User not logged in, redirecting to login page');
        Navigator.pushReplacementNamed(context, LoginPage.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MY FAVORITES',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer2<FavoritesProvider, AuthProvider>(
        builder: (context, favoritesProvider, authProvider, child) {
          developer.log(
              'Building favorites page. isLoading: ${favoritesProvider.isLoading}, favoriteIds: ${favoritesProvider.favoriteProductIds}');

          if (!authProvider.isLoggedIn) {
            return const Center(
              child: Text(
                'Please login to view favorites',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (favoritesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (favoritesProvider.favoriteProductIds.isEmpty) {
            return const Center(
              child: Text(
                'No favorite items yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(authProvider.userId)
                .collection('favorites')
                .snapshots(),
            builder: (context, snapshot) {
              developer.log(
                  'StreamBuilder state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, error: ${snapshot.error}');

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No favorite items found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final favorites = snapshot.data!.docs;
              developer.log('Found ${favorites.length} favorite items');

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favoriteData =
                      favorites[index].data() as Map<String, dynamic>;
                  final productId = favorites[index].id;
                  developer.log('Building product card for ID: $productId');

                  final product = Product(
                    id: productId,
                    name: favoriteData['title'] ?? '',
                    originalPrice:
                        favoriteData['originalPrice']?.toDouble() ?? 0.0,
                    discountedPrice: favoriteData['price']?.toDouble() ?? 0.0,
                    imageUrl: favoriteData['image'] != null &&
                            favoriteData['image']['src'] != null
                        ? 'https:${favoriteData['image']['src']}'
                        : favoriteData['imageUrl'] ?? '',
                    category: favoriteData['category'] ?? '',
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: product,
                            imageUrl: product.imageUrl,
                            collectionPath: favoriteData['collectionPath'],
                            documentPath: favoriteData['documentPath'],
                            subcollectionPath:
                                favoriteData['subcollectionPath'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      favoritesProvider.toggleFavorite(
                                        productId,
                                        product: product,
                                        collectionPath:
                                            favoriteData['collectionPath'],
                                        documentPath:
                                            favoriteData['documentPath'],
                                        subcollectionPath:
                                            favoriteData['subcollectionPath'],
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Removed from favorites'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'EGP ${product.discountedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(
                                        context,
                                        listen: false,
                                      ).addItem(product);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to cart'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    child: const Text(
                                      'ADD TO CART',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
