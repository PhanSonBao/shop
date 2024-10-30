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
                      right: index == products.length - 1
                          ? defaultPadding
                          : 0,
                    ),
                    child: ProductCard(
                      imageURL: product.image,
                      title: product.title,
                      price: product.price,
                      priceAfetDiscount: product.priceAfetDiscount,
                      dicountpercent: product.dicountpercent,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product,
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

// class PopularProducts extends StatelessWidget {
//   const PopularProducts({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: defaultPadding / 2),
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Text(
//             "Phổ biến",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ),
//         SizedBox(
//           height: 220,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             // Find demoPopularProducts on models/ProductModel.dart
//             itemCount: demoPopularProducts.length,
//             itemBuilder: (context, index) => Padding(
//               padding: EdgeInsets.only(
//                 left: defaultPadding,
//                 right: index == demoPopularProducts.length - 1
//                     ? defaultPadding
//                     : 0,
//               ),
//               child: ProductCard(
//                 image: demoPopularProducts[index].image,
//                 brandName: demoPopularProducts[index].brandName,
//                 title: demoPopularProducts[index].title,
//                 price: demoPopularProducts[index].price,
//                 priceAfetDiscount: demoPopularProducts[index].priceAfetDiscount,
//                 dicountpercent: demoPopularProducts[index].dicountpercent,
//                 press: () {
//                   Navigator.pushNamed(context, productDetailsScreenRoute,
//                       arguments: index.isEven);
//                 },
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
