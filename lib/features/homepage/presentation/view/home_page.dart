import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/homepage/presentation/widgets/homepage_widget.dart';
import 'package:townteam_app/features/search/presentation/pages/search_page.dart';
import 'package:townteam_app/features/product/presentaion/view/product_list_page.dart';
import '../widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> categories = [
    {
      'name': "Men's\nCollection",
      'imegeassets': 'assets/images/men.jpg',
      'path': 'men/closes',
      'subcategory': 'Boys Jackets',
      'title': 'Men'
    },
    {
      'name': 'Apparel-\nKids',
      'imegeassets': 'assets/images/summer_collection_kids.jpg',
      'path': 'kids/closes',
      'subcategory': 'Boys Jackets',
      'title': 'Kids'
    },
    {
      'name': 'New\nArrival',
      'imegeassets': 'assets/images/jacket2.jpg',
      'path': 'newarrival/newarrival',
      'subcategory': 'Men Jackets',
      'title': 'New Arrival'
    },
    {
      'name': 'Winter\n2025',
      'imegeassets': 'assets/images/sweatshirt.jpg',
      'path': 'winter/winter',
      'subcategory': 'Men Jackets',
      'title': 'Winter'
    },
  ];
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Text(
            'TOWN TEAM',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SearchPage.id);
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Search',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            // Category Circles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: categories
                    .map(
                      (category) => _buildCategoryCircle(context, category),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            HomePageWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCircle(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return GestureDetector(
      onTap: () {
        final pathParts = category['path'].split('/');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListPage(
              title: category['title'],
              collectionPath: pathParts[0],
              documentPath: pathParts[1],
              subcollectionPath: category['subcategory'],
              category: category['title'].toLowerCase(),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                category['imegeassets'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
