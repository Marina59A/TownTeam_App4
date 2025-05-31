import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrdersPage extends StatelessWidget {
  final String userId;
  const MyOrdersPage({required this.userId, Key? key}) : super(key: key);

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return '';
    if (createdAt is Timestamp) {
      return createdAt.toDate().toString();
    } else if (createdAt is String) {
      return createdAt;
    } else {
      return createdAt.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) return const Center(child: Text('No orders found.'));
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final cartItems = order['cartItems'] as List<dynamic>? ?? [];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${orders[index].id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, itemIndex) {
                          final item = cartItems[itemIndex] as Map<String, dynamic>? ?? {};
                          return ListTile(
                            leading: item['image'] != null && item['image'].toString().isNotEmpty
                                ? Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.image, size: 50),
                            title: Text(item['title']?.toString() ?? 'No Title'),
                            subtitle: Text('Quantity: ${item['quantity'] ?? '-'}'),
                          );
                        },
                      ),
                      if (order['createdAt'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Date: ${_formatDate(order['createdAt'])}'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 