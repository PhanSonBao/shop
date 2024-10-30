import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  final List<String> imageURL;

  ProductsModel({
    required this.imageURL,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });

  factory ProductsModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductsModel(
      imageURL: data['imageURL'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] as num).toDouble(),
      priceAfetDiscount: data['priceAfetDiscount'] != null
          ? (data['priceAfetDiscount'] as num).toDouble()
          : null,
      dicountpercent: data['dicountPercent'],
    );
  }
}