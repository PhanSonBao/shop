import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/checkout/components/checkout_button.dart';
import '../../../models/products_model.dart';
import 'empty_cart_screen.dart';
import '../components/coupon_code_input.dart';
import '../components/order_item.dart';
import '../components/order_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<List<ProductsModel>> fetchCartProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final cartDoc = await FirebaseFirestore.instance
          .collection('Carts')
          .doc(user.uid)
          .get();

      if (!cartDoc.exists || cartDoc.data() == null) return [];

      final productData =
          List<Map<String, dynamic>>.from(cartDoc.data()?['Products'] ?? []);
      return productData.map((data) => ProductsModel.fromMap(data)).toList();
    } catch (e) {
      // Log or handle the error gracefully
      debugPrint('Error fetching cart products: $e');
      return [];
    }
  }

  Future<void> removeProductFromCart(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get the user's cart document reference
    final cartDocRef =
        FirebaseFirestore.instance.collection('Carts').doc(user.uid);

    // Fetch the current cart data to find the exact product map
    final cartDoc = await cartDocRef.get();
    if (cartDoc.exists) {
      List<dynamic> products = cartDoc.data()?['Products'] ?? [];

      // Find the product map that matches the given productId
      final productToRemove = products.firstWhere(
        (product) => product['productId'] == productId,
        orElse: () => null,
      );

      // Check if the product exists in the list and remove it
      if (productToRemove != null) {
        await cartDocRef.update({
          'Products': FieldValue.arrayRemove([productToRemove])
        });
        setState(() {}); // Refresh the cart view
      }
    }
  }

  Future<void> updateCartItemQuantity(String productId, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDocRef =
        FirebaseFirestore.instance.collection('Carts').doc(user.uid);
    final cartDoc = await cartDocRef.get();

    if (cartDoc.exists) {
      final products =
          List<Map<String, dynamic>>.from(cartDoc['Products'] ?? []);
      final updatedProducts = products.map((product) {
        if (product['productId'] == productId) {
          return {
            ...product,
            'quantity': newQuantity,
          };
        }
        return product;
      }).toList();

      await cartDocRef.update({'Products': updatedProducts});
      setState(() {}); // Refresh the cart view
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductsModel>>(
      future: fetchCartProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error loading cart items')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If cart is empty, show EmptyCartScreen
          return const EmptyCartScreen();
        }

        final product = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Giỏ hàng (${product.length})', style: const TextStyle(fontSize: 18)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.pushNamed(context, entryPointScreenRoute),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // const Text(
              //   "Đơn hàng của bạn",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 16),
              ...product.map((product) => OrderItem(
                    product: product,
                    onDelete: () => removeProductFromCart(product.id),
                    onQuantityChanged: (quantity) =>
                        updateCartItemQuantity(product.id, quantity),
                  )),
              const SizedBox(height: 24),
              const CouponCodeInput(),
              const SizedBox(height: 24),
              OrderSummary(product: product),
              const SizedBox(height: 24),
              const CheckoutButton(),
            ],
          ),
        );
      },
    );
  }
}
