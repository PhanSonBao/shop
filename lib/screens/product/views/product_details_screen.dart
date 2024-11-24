import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  Future<void> checkBookmarkStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    try {
      final userSnapshot = await userDoc.get();
      final List<String> bookmarks =
          List<String>.from(userSnapshot.data()?['bookmarks'] ?? []);

      setState(() {
        isBookmarked = bookmarks.contains(widget.productId);
      });
    } catch (e) {
      debugPrint('Error checking bookmark status: $e');
    }
  }

  Future<void> toggleBookmark(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    try {
      final userSnapshot = await userDoc.get();

      List<String> currentBookmarks =
          List<String>.from(userSnapshot.data()?['bookmarks'] ?? []);

      if (currentBookmarks.contains(productId)) {
        // Remove the bookmark
        currentBookmarks.remove(productId);
        setState(() {
          isBookmarked = false;
        });
      } else {
        // Add the bookmark
        currentBookmarks.add(productId);
        setState(() {
          isBookmarked = true;
        });
      }

      await userDoc.update({'bookmarks': currentBookmarks});
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
    }
  }

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
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () => toggleBookmark(widget.productId),
                icon: SvgPicture.asset(
                  isBookmarked
                      ? "assets/icons/Bookmark_fill.svg"
                      : "assets/icons/Bookmark.svg",
                      color: isBookmarked ? Colors.red : Theme.of(context).iconTheme.color,
                ),
              ),
            ],
          ),
          bottomNavigationBar: productData['isAvailable'] == true
              ? CartButton(
                  price: productData['price'].toDouble(),
                  priceAfterDiscount:
                      productData['priceAfterDiscount']?.toDouble(),
                  press: () {
                    customModalBottomSheet(
                      context,
                      height: MediaQuery.of(context).size.height * 0.92,
                      child: ProductBuyNowScreen(productId: widget.productId),
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
                ProductImages(
                  images: List<String>.from(productData['imageURL']),
                ),
                ProductInfo(
                  brand: productData['brandName']?? 'Couple TX',
                  title: productData['title'],
                  isAvailable: productData['isAvailable'] ?? false,
                  description: productData['description'],
                  rating: 5,
                  numOfReviews: 0,
                ),
                // ... (keep the rest of the slivers as is)
                ProductListTile(
                  svgSrc: "assets/icons/Product.svg",
                  title: "Chi tiết sản phẩm",
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
                  title: "Thông Tin Vận Chuyển",
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
                  title: "Hoàn Trả",
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
                  title: "Đánh Giá",
                  isShowBottomBorder: true,
                  press: () {
                    Navigator.pushNamed(context, productReviewsScreenRoute);
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Bạn cũng có thể thích",
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
                                brandName: productData['brandName'] ?? 'Couple TX',
                                price: productData['price'].toDouble(),
                                priceAfetDiscount:
                                    productData['priceAfterDiscount']
                                        ?.toDouble(),
                                discountPercent:
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
