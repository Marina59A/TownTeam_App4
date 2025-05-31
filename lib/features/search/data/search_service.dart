import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:isolate';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
    try {
      print('Starting search for term: $searchTerm');
      
      // Convert the search term to lowercase for case-insensitive search
      searchTerm = searchTerm.toLowerCase().trim();

      if (searchTerm.isEmpty) {
        print('Search term is empty, returning empty results');
        return [];
      }

      // Define the collection paths to search in
      final List<Map<String, String>> searchPaths = [
        {'collection': 'summer', 'doc': 'summer', 'subcollection': 'Men T-shirts'},
        {'collection': 'summer', 'doc': 'summer', 'subcollection': 'Men Polo shirts'},
        {'collection': 'men', 'doc': 'closes', 'subcollection': 'Boys Jackets'},
        {'collection': 'men', 'doc': 'closes', 'subcollection': 'Boys Pullovers'},
        {'collection': 'men', 'doc': 'closes', 'subcollection': 'Boys Sweatshirts'},
        {'collection': 'kids', 'doc': 'closes', 'subcollection': 'Boys Sweatshirts'},
        // trousers subcollections
        {'collection': 'men', 'doc': 'trousers', 'subcollection': 'Jeans'},
        {'collection': 'men', 'doc': 'trousers', 'subcollection': 'Joggers'},
        {'collection': 'men', 'doc': 'trousers', 'subcollection': 'Pants'},
        {'collection': 'men', 'doc': 'trousers', 'subcollection': 'Relaxed Fit'},
        // shoes subcollections
        {'collection': 'men', 'doc': 'shoes', 'subcollection': 'Sneakers'},
        {'collection': 'men', 'doc': 'shoes', 'subcollection': 'Casual'},
        {'collection': 'men', 'doc': 'shoes', 'subcollection': 'Leather'},
        {'collection': 'men', 'doc': 'shoes', 'subcollection': 'Canvas'},
        {'collection': 'men', 'doc': 'shoes', 'subcollection': 'Sport'},
      ];

      // Create a list of futures for parallel execution
      final List<Future<List<Map<String, dynamic>>>> searchFutures = searchPaths.map((path) async {
        try {
          print('Searching in path: ${path['collection']}/${path['doc']}/${path['subcollection']}');
          QuerySnapshot result;
          if (path['subcollection'] != null && path['subcollection']!.isNotEmpty) {
            result = await _firestore
                .collection(path['collection']!)
                .doc(path['doc'])
                .collection(path['subcollection']!)
                .get();
          } else {
            result = await _firestore
                .collection(path['collection']!)
                .doc(path['doc'])
                .collection('products')
                .get();
          }

          print('Found ${result.docs.length} documents in this path');

          // Filter documents where title or category/subcollection contains the search term
          final filteredDocs = result.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = (data['title'] ?? '').toString().toLowerCase();
            final categoryField = (data['category'] ?? '').toString().toLowerCase();
            final subcollection = path['subcollection']!.toLowerCase();
            final matchesTitle = title.contains(searchTerm);
            final matchesCategoryField = categoryField.contains(searchTerm);
            final matchesSubcollection = subcollection.contains(searchTerm);
            final matches = matchesTitle || matchesCategoryField || matchesSubcollection;
            if (matches) {
              print('Found matching product: $title in $subcollection');
            }
            return matches;
          }).toList();

          print('Filtered to ${filteredDocs.length} matching documents');

          // Return filtered documents with collection info
          return filteredDocs.map((doc) => {
            'id': doc.id,
            'collection': path['collection'],
            'subcollection': path['subcollection'],
            ...doc.data() as Map<String, dynamic>,
          }).toList();
        } catch (e) {
          print('Error searching in ${path['collection']}/${path['doc']}/${path['subcollection']}: $e');
          return <Map<String, dynamic>>[];
        }
      }).toList();

      // Wait for all searches to complete
      final List<List<Map<String, dynamic>>> results = await Future.wait(searchFutures);
      
      // Flatten the results
      final List<Map<String, dynamic>> allResults = results.expand((x) => x).toList();

      print('Total search results: ${allResults.length}');
      return allResults;
    } catch (e) {
      print('Error in searchProducts: $e');
      return [];
    }
  }

  // Save recent search
  Future<void> saveRecentSearch(String userId, String searchTerm) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'recentSearches': FieldValue.arrayUnion([searchTerm])
      });
    } catch (e) {
      print('Error saving recent search: $e');
    }
  }

  // Get recent searches for a user
  Future<List<String>> getRecentSearches(String userId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('recentSearches')) {
          return List<String>.from(data['recentSearches']);
        }
      }
      return [];
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  // Get popular collections
  Future<List<Map<String, dynamic>>> getPopularCollections() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('collections')
          .where('isPopular', isEqualTo: true)
          .get();

      return result.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      print('Error getting popular collections: $e');
      return [];
    }
  }
}