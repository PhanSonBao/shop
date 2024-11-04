import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String id, title, brandName;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  final List<String> imageURL;

  ProductsModel({
    required this.id,
    required this.brandName,
    required this.imageURL,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });

  factory ProductsModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductsModel(
      id: doc.id,
      imageURL: List<String>.from(data['imageURL'] ?? []),
      brandName: data['brandName'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] as num).toDouble(),
      priceAfetDiscount: data['priceAfterDiscount'] != null
          ? (data['priceAfterDiscount'] as num).toDouble()
          : null,
      dicountpercent: data['discountPercent'],
    );
  }
}