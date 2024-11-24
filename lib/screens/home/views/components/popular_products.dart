import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/models/products_model.dart';

import '../../../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Phổ biến",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 220,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Products')
                .where('isPopular', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Không có sản phẩm nào"));
              }

              final products = snapshot.data!.docs
                  .map((doc) => ProductsModel.fromDocument(doc))
                  .toList();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child: ProductCard(
                      image: product.imageURL[0],
                      brandName: product.brandName ?? 'Couple TX',
                      title: product.title,
                      price: product.price,
                      priceAfetDiscount: product.priceAfterDiscount,
                      discountPercent: product.discountPercent,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product.id,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}