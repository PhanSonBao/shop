import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/route/route_constants.dart';
import '../../../constants.dart';

class OnSaleScreen extends StatelessWidget {
  final Query<Map<String, dynamic>> query;

  const OnSaleScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sản phẩm"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có sản phẩm nào"));
          }

          if (snapshot.hasData) {
            debugPrint("Products found: ${snapshot.data!.docs.length}");
          } else {
            debugPrint("No data found. Snapshot error: ${snapshot.error}");
          }

          final products = snapshot.data!.docs;

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
                      final product = products[index];
                      return SecondaryProductCard(
                        image: product['imageURL'][0],
                        brandName: product['brandName'] ?? 'Đang cập nhật',
                        title: product['title'],
                        price: product['price'].toDouble(),
                        priceAfetDiscount:
                            product['priceAfterDiscount']?.toDouble(),
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
                    childCount: products.length,
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
