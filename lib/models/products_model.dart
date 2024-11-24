import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsModel {
  final String id, title;
  final double price;
  final int quantity;
  final double? priceAfterDiscount;
  final int? discountPercent;
  final String? gender, brandName;
  final String? size;

  final Color? color;
  final List<String> imageURL;

  ProductsModel({
    required this.id,
    required this.imageURL,
    required this.title,
    required this.price,
    required this.quantity,
    this.brandName,
    this.color,
    this.size,
    this.gender,
    this.priceAfterDiscount,
    this.discountPercent,
  });

  factory ProductsModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductsModel(
      id: doc.id,
      imageURL: List<String>.from(data['imageURL'] ?? []),
      brandName: data['brandName'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] ?? 1,
      priceAfterDiscount: data['priceAfterDiscount'] != null
          ? (data['priceAfterDiscount'] as num).toDouble()
          : null,
      discountPercent: data['discountPercent'],
    );
  }

  factory ProductsModel.fromMap(Map<String, dynamic> data) {
    return ProductsModel(
      id: data['productId'] ?? '',
      imageURL: List<String>.from(data['imageURL'] ?? []),
      brandName: data['brandName'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] ?? 1,
      color: hexToColor(data['color'] ?? '#000000'),
      size: data['size'] ?? '',
      gender: data['gender'],
      priceAfterDiscount: data['priceAfterDiscount'] != null
          ? (data['priceAfterDiscount'] as num).toDouble()
          : null,
      discountPercent: data['discountPercent'],
    );
  }
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // Add alpha value if not provided (defaults to fully opaque)
  }
  return Color(int.parse('0x$hex'));
}