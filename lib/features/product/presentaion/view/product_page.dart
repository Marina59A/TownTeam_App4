import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/common/models/nav_provider.dart';
import 'package:townteam_app/common/models/product.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/product/presentaion/view/product_details_page.dart';

class ProductPage extends StatefulWidget {
  // final String category;
  final String subcategory;
  final String path;
  final String title;

  const ProductPage(
      {super.key,
      required this.subcategory,
      required this.path,
      required this.title});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<NavProvider>(
          context,
          listen: false,
        ).setTitle(widget.title.toUpperCase());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .doc(widget.path)
            .collection(widget.subcategory)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var productData = snapshot.data!.docs[index];
              return _buildProductCard(context, productData);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    QueryDocumentSnapshot productData,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                var product = Product(
                  id: productData.id,
                  name: productData['title'] ?? 'No Title',
                  originalPrice: productData['price'] != null
                      ? productData['price']['amount']?.toDouble() ?? 0.0
                      : 0.0,
                  discountedPrice: productData['price'] != null
                      ? productData['price']['amount']?.toDouble() ?? 0.0
                      : 0.0,
                  imageUrl: productData['image'] != null &&
                          productData['image']['src'] != null
                      ? 'https:${productData['image']['src']}'
                      : '',
                  category: widget.title,
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
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(5),
                  ),
                  image: DecorationImage(
                    image: productData['image'] != null &&
                            productData['image']['src'] != null
                        ? NetworkImage('https:${productData['image']['src']}')
                        : const AssetImage('assets/placeholder_image.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
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
                          productData['price']['amount'] != null
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
                        name: productData['title'] ?? 'No Title',
                        originalPrice: productData['price'] != null
                            ? productData['price']['amount']?.toDouble() ?? 0.0
                            : 0.0,
                        discountedPrice: productData['price'] != null
                            ? productData['price']['amount']?.toDouble() ?? 0.0
                            : 0.0,
                        imageUrl: productData['image'] != null &&
                                productData['image']['src'] != null
                            ? 'https:${productData['image']['src']}'
                            : '',
                        category: widget.title,
                      );

                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).addItem(product);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
    );
  }
}
