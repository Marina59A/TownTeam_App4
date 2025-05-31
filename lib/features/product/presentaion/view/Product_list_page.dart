import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/common/models/product.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/product/presentaion/view/product_details_page.dart';

class ProductListPage extends StatelessWidget {
  final String title;
  final String collectionPath;
  final String documentPath;
  final String subcollectionPath;
  final String category;

  const ProductListPage({
    super.key,
    required this.title,
    required this.collectionPath,
    required this.documentPath,
    required this.subcollectionPath,
    required this.category,
  });

  // Factory constructors for different product types
  factory ProductListPage.mensJackets() {
    return const ProductListPage(
      title: "MEN'S JACKETS",
      collectionPath: 'men',
      documentPath: 'closes',
      subcollectionPath: 'Boys Jackets',
      category: 'men',
    );
  }

  factory ProductListPage.mensSweatshirts() {
    return const ProductListPage(
      title: "MEN'S SWEATSHIRTS",
      collectionPath: 'winter',
      documentPath: 'winter',
      subcollectionPath: 'Men Sweatshirts',
      category: 'men',
    );
  }

  factory ProductListPage.mensPullovers() {
    return const ProductListPage(
      title: "MEN'S PULLOVERS",
      collectionPath: 'men',
      documentPath: 'closes',
      subcollectionPath: 'Boys Pullovers',
      category: 'men',
    );
  }

  factory ProductListPage.mensShirts() {
    return const ProductListPage(
      title: "MEN'S SHIRTS",
      collectionPath: 'summer',
      documentPath: 'summer',
      subcollectionPath: 'Men Polo shirts',
      category: 'men',
    );
  }

  factory ProductListPage.mensSportswear() {
    return const ProductListPage(
      title: "MEN'S SPORTSWEAR",
      collectionPath: 'allcollections',
      documentPath: 'shoes',
      subcollectionPath: 'Sneakers',
      category: 'men',
    );
  }

  factory ProductListPage.kidsJackets() {
    return const ProductListPage(
      title: "KIDS JACKETS",
      collectionPath: 'kids',
      documentPath: 'closes',
      subcollectionPath: 'Boys Jackets',
      category: 'kids',
    );
  }

  factory ProductListPage.kidsSweatshirts() {
    return const ProductListPage(
      title: "KIDS SWEATSHIRTS",
      collectionPath: 'kids',
      documentPath: 'closes',
      subcollectionPath: 'Boys Sweatshirts',
      category: 'kids',
    );
  }

  factory ProductListPage.kidsPullovers() {
    return const ProductListPage(
      title: "KIDS PULLOVERS",
      collectionPath: 'kids',
      documentPath: 'closes',
      subcollectionPath: 'Boys Pullovers',
      category: 'kids',
    );
  }

  factory ProductListPage.kidsJeans() {
    return const ProductListPage(
      title: "KIDS JEANS",
      collectionPath: 'kids',
      documentPath: 'trousers',
      subcollectionPath: 'Jeans',
      category: 'kids',
    );
  }

  factory ProductListPage.bags() {
    return const ProductListPage(
      title: "BAGS",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Bags',
      category: 'accessories',
    );
  }

  factory ProductListPage.bodySplash() {
    return const ProductListPage(
      title: "BODY SPLASH",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Body Splash',
      category: 'accessories',
    );
  }

  factory ProductListPage.deodorants() {
    return const ProductListPage(
      title: "DEODORANTS",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Deodorant',
      category: 'accessories',
    );
  }

  factory ProductListPage.iceCaps() {
    return const ProductListPage(
      title: "ICE CAPS",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Ice Caps',
      category: 'accessories',
    );
  }

  factory ProductListPage.socks() {
    return const ProductListPage(
      title: "SOCKS",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Socks',
      category: 'accessories',
    );
  }

  factory ProductListPage.wallets() {
    return const ProductListPage(
      title: "WALLETS",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Wallets',
      category: 'accessories',
    );
  }

  factory ProductListPage.perfumes() {
    return const ProductListPage(
      title: "PERFUMES",
      collectionPath: 'men',
      documentPath: 'accessories',
      subcollectionPath: 'Perfumes',
      category: 'accessories',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.id);
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return cartProvider.items.isEmpty
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartProvider.items.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(collectionPath)
                  .doc(documentPath)
                  .collection(subcollectionPath)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var productData = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to product details
                        final product = Product(
                          id: productData.id,
                          name: productData['title'] ?? 'No Title',
                          originalPrice: productData['price'] != null
                              ? productData['price']['amount']?.toDouble() ??
                                  0.0
                              : 0.0,
                          discountedPrice: productData['price'] != null
                              ? productData['price']['amount']?.toDouble() ??
                                  0.0
                              : 0.0,
                          imageUrl: productData['image'] != null &&
                                  productData['image']['src'] != null
                              ? 'https:${productData['image']['src']}'
                              : '',
                          category: category,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              product: product,
                              imageUrl: product.imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https:${productData['image']['src']}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    productData['price'] != null &&
                                            productData['price']['amount'] !=
                                                null
                                        ? 'EGP ${productData['price']['amount'].toStringAsFixed(2)}'
                                        : 'Price not available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        var product = Product(
                                          id: productData.id,
                                          name: productData['title'] ??
                                              'No Title',
                                          originalPrice: productData['price'] !=
                                                  null
                                              ? productData['price']['amount']
                                                      ?.toDouble() ??
                                                  0.0
                                              : 0.0,
                                          discountedPrice:
                                              productData['price'] != null
                                                  ? productData['price']
                                                              ['amount']
                                                          ?.toDouble() ??
                                                      0.0
                                                  : 0.0,
                                          imageUrl: productData['image'] !=
                                                      null &&
                                                  productData['image']['src'] !=
                                                      null
                                              ? 'https:${productData['image']['src']}'
                                              : '',
                                          category: category,
                                        );

                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        ).addItem(product);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Added to cart'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to Cart',
                                        style: TextStyle(color: Colors.white),
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
            ),
          ),
        ],
      ),
    );
  }
}
