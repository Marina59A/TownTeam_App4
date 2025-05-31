import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchProducts(String searchTerm) async {
    try {
      searchTerm = searchTerm.toLowerCase();

      final List<Map<String, dynamic>> allResults = [];

      final mensSnapshot = await _firestore
          .collection('categories')
          .doc('men')
          .collection('products')
          .get();

      // Search in Women's collection
      final womensSnapshot = await _firestore
          .collection('categories')
          .doc('women')
          .collection('products')
          .get();

      // Search in Kids' collection
      final kidsSnapshot = await _firestore
          .collection('categories')
          .doc('kids')
          .collection('products')
          .get();

      bool matchesSearch(DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = (data['name'] ?? '').toString().toLowerCase();
        final description =
            (data['description'] ?? '').toString().toLowerCase();
        return name.contains(searchTerm) || description.contains(searchTerm);
      }

      // Process Men's results
      allResults.addAll(mensSnapshot.docs.where(matchesSearch).map((doc) => {
            'id': doc.id,
            'category': 'men',
            ...doc.data() as Map<String, dynamic>,
          }));

      // Process Women's results
      allResults.addAll(womensSnapshot.docs.where(matchesSearch).map((doc) => {
            'id': doc.id,
            'category': 'women',
            ...doc.data() as Map<String, dynamic>,
          }));

      // Process Kids' results
      allResults.addAll(kidsSnapshot.docs.where(matchesSearch).map((doc) => {
            'id': doc.id,
            'category': 'kids',
            ...doc.data() as Map<String, dynamic>,
          }));

      return allResults;
    } catch (e) {
      print('Error searching products: $e');
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
