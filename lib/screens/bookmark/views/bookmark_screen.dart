import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/route/route_constants.dart';
import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchBookmarkedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      // Fetch user's bookmarked product IDs
      final bookmarksDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      final bookmarkedIds = List<String>.from(bookmarksDoc.data()?['bookmarks'] ?? []);

      if (bookmarkedIds.isEmpty) return [];

      // Fetch product details for each bookmarked product ID
      final bookmarkedProducts = await Future.wait(
        bookmarkedIds.map((id) async {
          final productDoc = await FirebaseFirestore.instance
              .collection('Products')
              .doc(id)
              .get();

          if (productDoc.exists) {
            return productDoc.data();
          } else {
            return null;
          }
        }),
      );

      // Filter out any null values
      return bookmarkedProducts.where((product) => product != null).cast<Map<String, dynamic>>().toList();
    } catch (e) {
      debugPrint('Error fetching bookmarks: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookmarkedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarked products found.'));
          }

          final bookmarkedProducts = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final product = bookmarkedProducts[index];
                      return SecondaryProductCard(
                        image: product['imageURL'][0],
                        brandName: product['brandName'],
                        title: product['title'],
                        price: product['price'].toDouble(),
                        priceAfetDiscount: product['priceAfterDiscount']?.toDouble(),
                        discountPercent: product['discountPercent'],
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: product['productId'],
                          );
                        },
                      );
                    },
                    childCount: bookmarkedProducts.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}