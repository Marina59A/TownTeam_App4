import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:townteam_app/common/models/auth_provider.dart';
import 'package:townteam_app/common/models/cart_provider.dart';
import 'package:townteam_app/common/services/paypal.dart';
import 'package:townteam_app/features/payment/presentation/view/payment_page.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:townteam_app/features/orders/presentation/my_orders_page.dart';
import 'dart:async';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> startPayPalCheckout(List cartItems) async {
    final token = await PayPalService.getAccessToken();
    if (token == null || !mounted) return;

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.discountedPrice * item.quantity),
    );

    final orderId = await PayPalService.createOrder(
      token,
      total.toStringAsFixed(2),
    );
    if (orderId == null || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          checkoutUrl:
              "https://www.sandbox.paypal.com/checkoutnow?token=$orderId",
        ),
      ),
    );
  }

  Future<void> showCheckoutDialog(
      List cartItems, String userId, String? userEmail) async {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String address = '';
    String phone = '';
    String city = '';
    String paymentMethod = 'cod';
    String? transactionId;
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Checkout'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your name' : null,
                        onChanged: (v) => name = v,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Enter your address'
                            : null,
                        onChanged: (v) => address = v,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Phone'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your phone' : null,
                        onChanged: (v) => phone = v,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter your city' : null,
                        onChanged: (v) => city = v,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Cash on Delivery'),
                              value: 'cod',
                              groupValue: paymentMethod,
                              onChanged: (v) =>
                                  setState(() => paymentMethod = v!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('PayPal'),
                              value: 'paypal',
                              groupValue: paymentMethod,
                              onChanged: (v) =>
                                  setState(() => paymentMethod = v!),
                            ),
                          ),
                        ],
                      ),
                      if (isLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          setState(() => isLoading = true);
                          try {
                            if (paymentMethod == 'paypal') {
                              final token =
                                  await PayPalService.getAccessToken();
                              if (token == null)
                                throw Exception('PayPal token error');
                              final total = cartItems.fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      (item.product.discountedPrice *
                                          item.quantity));
                              final orderId = await PayPalService.createOrder(
                                  token, total.toStringAsFixed(2));
                              if (orderId == null)
                                throw Exception('PayPal order error');
                              transactionId = orderId;
                            }
                            final orderData = {
                              'address': address,
                              'cartItems': cartItems
                                  .map((item) => {
                                        'category': item.product.category,
                                        'id': item.product.id,
                                        'image': item.product.imageUrl,
                                        'price': item.product.discountedPrice,
                                        'quantity': item.quantity,
                                        'title': item.product.name,
                                        'unitPrice':
                                            item.product.discountedPrice,
                                      })
                                  .toList(),
                              'city': city,
                              'createdAt': DateTime.now().toIso8601String(),
                              'email': userEmail ?? '',
                              'firstName': name,
                              'lastName': '',
                              'paymentMethod': paymentMethod,
                              'phone': phone,
                              'total': cartItems.fold<double>(
                                  0,
                                  (sum, item) =>
                                      sum +
                                      (item.product.discountedPrice *
                                          item.quantity)),
                              'transactionId': transactionId,
                              'userId': userId,
                            };
                            await placeOrder(orderData);
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Order placed successfully!')));
                              Provider.of<CartProvider>(context, listen: false)
                                  .clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyOrdersPage(userId: userId),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to place order.')));
                          }
                        },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> placeOrder(Map<String, dynamic> orderData) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add(orderData);
    } catch (e) {
      print('Error placing order: $e');
      rethrow;
    }
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
        title: const Text(
          'CART',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer2<CartProvider, AuthProvider>(
        builder: (context, cartProvider, authProvider, child) {
          if (cartProvider.items.isEmpty) {
            return const Center(
              child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
            );
          }

          final cartItems = cartProvider.items.values.toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(item.product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.product.selectedColor} / ${item.product.selectedSize}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove,
                                                  size: 20),
                                              onPressed: () {
                                                cartProvider.decreaseQuantity(
                                                    item.product);
                                              },
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add,
                                                  size: 20),
                                              onPressed: () {
                                                cartProvider.increaseQuantity(
                                                    item.product);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'EGP ${item.product.discountedPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                cartProvider.removeItem(item.product.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SUBTOTAL:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'EGP ${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (authProvider.isLoggedIn) {
                            await showCheckoutDialog(cartItems,
                                authProvider.userId!, authProvider.userEmail);
                          } else {
                            Navigator.pushNamed(context, LoginPage.id);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          authProvider.isLoggedIn
                              ? 'CHECKOUT'
                              : 'LOGIN TO CHECKOUT',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
