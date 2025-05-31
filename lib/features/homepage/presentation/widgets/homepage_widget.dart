import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:townteam_app/common/models/product.dart';
import 'package:townteam_app/features/product/presentaion/view/product_details_page.dart';
import 'package:townteam_app/features/product/presentaion/view/product_list_page.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  // Define fixed categories and their paths
  static const Map<String, Map<String, String>> categories = {
    'summer_polo': {
      'path': 'summer/summer',
      'collection': 'Men Polo shirts',
      'title': 'Summer Polo',
      'category': 'men'
    },
    'summer_tshirts': {
      'path': 'summer/summer',
      'collection': 'Men T-shirts',
      'title': 'Summer T-Shirts',
      'category': 'men'
    },
    'kids_sweatshirts': {
      'path': 'kids/closes',
      'collection': 'Boys Sweatshirts',
      'title': 'Kids Sweatshirts',
      'category': 'kids'
    },
    'mens_jeans': {
      'path': 'men/trousers',
      'collection': 'Jeans',
      'title': 'Men\'s Jeans',
      'category': 'men'
    }
  };

  Widget _buildProductList(String categoryKey, BuildContext context) {
    final category = categories[categoryKey]!;
    final pathParts = category['path']!.split('/');

    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(pathParts[0])
            .doc(pathParts[1])
            .collection(category['collection']!)
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
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var productData = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  final product = Product(
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
                    category: category['category']!,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https:${productData['image']['src']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/last_chance.jpg'),
        GestureDetector(
          onTap: () {
            final category = categories['summer_polo']!;
            final pathParts = category['path']!.split('/');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListPage(
                  title: category['title']!,
                  collectionPath: pathParts[0],
                  documentPath: pathParts[1],
                  subcollectionPath: category['collection']!,
                  category: category['category']!,
                ),
              ),
            );
          },
          child: Image.asset('assets/images/shirt.jpg'),
        ),
        const SizedBox(height: 10),
        _buildProductList('summer_polo', context),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            final category = categories['summer_tshirts']!;
            final pathParts = category['path']!.split('/');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListPage(
                  title: category['title']!,
                  collectionPath: pathParts[0],
                  documentPath: pathParts[1],
                  subcollectionPath: category['collection']!,
                  category: category['category']!,
                ),
              ),
            );
          },
          child: Image.asset('assets/images/t-shirt.jpg'),
        ),
        const SizedBox(height: 10),
        _buildProductList('summer_tshirts', context),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            final category = categories['kids_sweatshirts']!;
            final pathParts = category['path']!.split('/');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListPage(
                  title: category['title']!,
                  collectionPath: pathParts[0],
                  documentPath: pathParts[1],
                  subcollectionPath: category['collection']!,
                  category: category['category']!,
                ),
              ),
            );
          },
          child: Image.asset('assets/images/kids_collection.jpg'),
        ),
        const SizedBox(height: 10),
        _buildProductList('kids_sweatshirts', context),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            final category = categories['mens_jeans']!;
            final pathParts = category['path']!.split('/');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListPage(
                  title: category['title']!,
                  collectionPath: pathParts[0],
                  documentPath: pathParts[1],
                  subcollectionPath: category['collection']!,
                  category: category['category']!,
                ),
              ),
            );
          },
          child: Image.asset('assets/images/denim_collection.jpg'),
        ),
      ],
    );
  }
}
