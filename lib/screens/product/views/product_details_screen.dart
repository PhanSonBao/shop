import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';

import 'package:shop/route/screen_export.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productId)
          .get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Product not found'));
        }

        final productData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          bottomNavigationBar: productData['isAvailable'] == true
              ? CartButton(
                  price: productData['price'].toDouble(),
                  press: () {
                    customModalBottomSheet(
                      context,
                      height: MediaQuery.of(context).size.height * 0.92,
                      child: const ProductBuyNowScreen(),
                    );
                  },
                )
              : NotifyMeCard(
                  isNotify: false,
                  onChanged: (value) {},
                ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ... (keep the SliverAppBar as is)
                ProductImages(
                  images: List<String>.from(productData['imageURL']),
                ),
                ProductInfo(
                  brand: productData['brandName'],
                  title: productData['title'],
                  isAvailable: productData['isAvailable'],
                  description: productData['description'],
                  rating: 5,
                  numOfReviews: 0,
                ),
                // ... (keep the rest of the slivers as is)
                ProductListTile(
                  svgSrc: "assets/icons/Product.svg",
                  title: "Product Details",
                  press: () {
                    customModalBottomSheet(
                      context,
                      height: MediaQuery.of(context).size.height * 0.92,
                      child: const BuyFullKit(
                          images: ["assets/screens/Product detail.png"]),
                    );
                  },
                ),
                ProductListTile(
                  svgSrc: "assets/icons/Delivery.svg",
                  title: "Shipping Information",
                  press: () {
                    customModalBottomSheet(
                      context,
                      height: MediaQuery.of(context).size.height * 0.92,
                      child: const BuyFullKit(
                        images: ["assets/screens/Shipping information.png"],
                      ),
                    );
                  },
                ),
                ProductListTile(
                  svgSrc: "assets/icons/Return.svg",
                  title: "Returns",
                  isShowBottomBorder: true,
                  press: () {
                    customModalBottomSheet(
                      context,
                      height: MediaQuery.of(context).size.height * 0.92,
                      child: const ProductReturnsScreen(),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: ReviewCard(
                      rating: 4.3,
                      numOfReviews: 128,
                      numOfFiveStar: 80,
                      numOfFourStar: 30,
                      numOfThreeStar: 5,
                      numOfTwoStar: 4,
                      numOfOneStar: 1,
                    ),
                  ),
                ),
                ProductListTile(
                  svgSrc: "assets/icons/Chat.svg",
                  title: "Reviews",
                  isShowBottomBorder: true,
                  press: () {
                    Navigator.pushNamed(context, productReviewsScreenRoute);
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "You may also like",
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Products')
                          .limit(5)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final productData = snapshot.data!.docs[index]
                                .data() as Map<String, dynamic>;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: defaultPadding,
                                right: index == snapshot.data!.docs.length - 1
                                    ? defaultPadding
                                    : 0,
                              ),
                              child: ProductCard(
                                image: productData['imageURL'][0],
                                title: productData['title'],
                                brandName: productData['brandName'],
                                price: productData['price'].toDouble(),
                                priceAfetDiscount:
                                    productData['discountedPrice']?.toDouble(),
                                dicountpercent:
                                    productData['discountPercentage'],
                                press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                              productId: snapshot
                                                  .data!.docs[index].id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: defaultPadding),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
