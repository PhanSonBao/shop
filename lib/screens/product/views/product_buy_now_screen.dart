// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/screens/product/views/components/product_list_tile.dart';
import 'package:shop/screens/product/views/size_guide_screen.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductBuyNowScreen extends StatefulWidget {
  final String productId;

  const ProductBuyNowScreen({super.key, required this.productId});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  late Future<DocumentSnapshot> productFuture;
  Color? selectedColor;
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    productFuture = FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.productId)
        .get();
  }

  Future<void> addProductToCart(Map<String, dynamic> productData) async {
    // Get the current user's cart document
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc =
        FirebaseFirestore.instance.collection('Carts').doc(user.uid);

    await cartDoc.set({
      'Products': FieldValue.arrayUnion([
        {
          'productId': widget.productId,
          'title': productData['title'],
          'brandName': productData['brandName'],
          'price': productData['price'],
          'priceAfterDiscount': productData['priceAfterDiscount'],
          'imageURL': productData['imageURL'],
          'quantity': 1,
          'color': selectedColor ?? productData['color'][0],
          'size': selectedSize ?? productData['size'][0],
          'gender': productData['gender'],
        }
      ]),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: productFuture,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          bottomNavigationBar: CartButton(
            price: productData['price']?.toDouble() ?? 0.0,
            priceAfterDiscount: productData['priceAfterDiscount']?.toDouble(),
            title: "Thêm vào giỏ hàng",
            press: () async {
              await addProductToCart(productData);
              if (context.mounted) {
                customModalBottomSheet(
                  context,
                  isDismissible: false,
                  child: const AddedToCartMessageScreen(),
                );
              }
            },
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2, vertical: defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(),
                    Text(
                      productData['title'] != null &&
                              productData['title'].length > 30
                          ? '${productData['title'].substring(0, 30)}...'
                          : productData['title'] ?? '',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: AspectRatio(
                          aspectRatio: 1.05,
                          child: NetworkImageWithLoader(
                              productData['imageURL'][0] ?? ''),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: UnitPrice(
                                price: productData['price']?.toDouble() ?? 0.0,
                                priceAfterDiscount:
                                    productData['priceAfterDiscount']
                                            ?.toDouble() ??
                                        productData['price']?.toDouble() ??
                                        0.0,
                              ),
                            ),
                            ProductQuantity(
                              numOfItem: 1,
                              onIncrement: () {},
                              onDecrement: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: Divider()),
                    SliverToBoxAdapter(
                      child: SelectedColors(
                        colors: productData['color']
                            .map<Color>((colorString) => Color(int.parse(
                                colorString.replaceFirst('#', '0xff'))))
                            .toList(),
                        selectedColorIndex: 0,
                        press: (value) {
                          setState(() {
                            selectedColor = Color(
                              int.parse(productData['color'][value]
                                  .replaceFirst('#', '0xff')),
                            ) as Color?;
                          });
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SelectedSize(
                        sizes: List<String>.from(productData['size']),
                        selectedIndex: 0,
                        press: (value) {
                          setState(() {
                            selectedSize = productData['size'][value];
                          });
                        },
                      ),
                    ),
                    SliverPadding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      sliver: ProductListTile(
                        title: "Hướng dẫn chọn kích cỡ",
                        svgSrc: "assets/icons/Sizeguid.svg",
                        isShowBottomBorder: true,
                        press: () {
                          customModalBottomSheet(
                            context,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: const SizeGuideScreen(),
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: defaultPadding))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
