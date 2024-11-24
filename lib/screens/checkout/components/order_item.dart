import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/constants.dart';
import '../../../models/products_model.dart';

class OrderItem extends StatelessWidget {
  final ProductsModel product;
  final VoidCallback onDelete;
  final ValueChanged<int> onQuantityChanged;

  const OrderItem({
    required this.product,
    required this.onDelete,
    required this.onQuantityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat("#,##0", "en_US").format(product.price);
    final formattedDiscountPrice = product.priceAfterDiscount != null
        ? NumberFormat("#,##0", "en_US").format(product.priceAfterDiscount)
        : null;

    int quantity = product.quantity;

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageURL.isNotEmpty
                      ? product.imageURL[0]
                      : 'https://via.placeholder.com/150',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              // const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: whileColor40),
                    label: const Text('Xoá sản phẩm',
                        style: TextStyle(color: whileColor40, fontSize: 12)),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Màu sắc:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: product.color as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Giới tính: ${product.gender}',
                      style: const TextStyle(
                        fontSize: 14, // Increased font size.
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kích thước: ${product.size}',
                      style: const TextStyle(
                        fontSize: 14, // Increased font size.
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "${formattedDiscountPrice ?? formattedPrice} VND",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    if (product.priceAfterDiscount != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        "$formattedPrice VND",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  onQuantityChanged(quantity + 1);
                },
                icon: const Icon(Icons.add, size: 18),
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (quantity > 1) {
                    onQuantityChanged(quantity - 1);
                  }
                },
                icon: const Icon(Icons.remove, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
