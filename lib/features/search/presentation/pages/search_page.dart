import 'package:flutter/material.dart';
import 'package:townteam_app/features/search/data/search_service.dart';
import 'package:townteam_app/common/models/product.dart';
import 'package:townteam_app/features/product/presentaion/view/product_details_page.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<String> recentSearches = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool hasSearched = false;

  // Suggested search terms
  final List<String> suggestedSearches = [
    'T-Shirts',
    'Polo Shirts',
    'Jeans',
    'Sweatshirts',
    'Sneakers',
    'Leather',
    'Casual',
  
   
  ];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    setState(() => isLoading = true);
    try {
      // TODO: Get actual user ID from auth service
      const String userId = 'current_user_id';
      final recentSearchesList = await _searchService.getRecentSearches(userId);
      setState(() {
        recentSearches = recentSearchesList;
      });
    } catch (e) {
      print('Error loading recent searches: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleSearch(String value) async {
    print('Handling search for: $value');
    
    if (value.isEmpty) {
      print('Search value is empty, clearing results');
      setState(() {
        searchResults = [];
        hasSearched = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    try {
      print('Calling search service...');
      final results = await _searchService.searchProducts(value);
      print('Search service returned ${results.length} results');
      
      // TODO: Get actual user ID from auth service
      const String userId = 'current_user_id';
      await _searchService.saveRecentSearch(userId, value);
      
      setState(() {
        searchResults = results;
      });
      print('Updated UI with search results');
    } catch (e) {
      print('Error in _handleSearch: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
          onSubmitted: (value) {
            print('Search submitted with value: $value');
            _handleSearch(value);
          },
          textInputAction: TextInputAction.search,
          autofocus: true,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                print('Clearing search');
                _searchController.clear();
                setState(() {
                  searchResults = [];
                  hasSearched = false;
                });
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hasSearched) ...[
                    if (recentSearches.isNotEmpty) ...[
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: recentSearches.map((search) {
                          return ActionChip(
                            label: Text(search),
                            onPressed: () {
                              print('Recent search selected: $search');
                              _searchController.text = search;
                              _handleSearch(search);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Suggested Searches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: suggestedSearches.map((search) {
                        return ActionChip(
                          label: Text(search),
                          onPressed: () {
                            print('Suggested search selected: $search');
                            _searchController.text = search;
                            _handleSearch(search);
                          },
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    Text(
                      'Search Results (${searchResults.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No products found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      print('Clearing search results');
                                      setState(() {
                                        hasSearched = false;
                                      });
                                    },
                                    child: const Text('Try different search terms'),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                final product = searchResults[index];
                                return _buildProductCard(context, product);
                              },
                            ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                print('Product tapped: ${product['title']}');
                final productModel = Product(
                  id: product['id'],
                  name: product['title'] ?? 'No Title',
                  originalPrice: product['price'] != null
                      ? product['price']['amount']?.toDouble() ?? 0.0
                      : 0.0,
                  discountedPrice: product['price'] != null
                      ? product['price']['amount']?.toDouble() ?? 0.0
                      : 0.0,
                  imageUrl: product['image'] != null &&
                          product['image']['src'] != null
                      ? 'https:${product['image']['src']}'
                      : '',
                  category: product['collection'] ?? '',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      product: productModel,
                      imageUrl: productModel.imageUrl,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: product['image'] != null &&
                            product['image']['src'] != null
                        ? NetworkImage('https:${product['image']['src']}')
                        : const AssetImage('assets/placeholder_image.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
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
                  product['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product['price'] != null &&
                          product['price']['amount'] != null
                      ? 'EGP ${product['price']['amount'].toStringAsFixed(2)}'
                      : 'Price not available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}