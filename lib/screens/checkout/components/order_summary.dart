import 'package:flutter/material.dart';
import 'package:shop/models/products_model.dart';

import 'summary_row.dart';
import 'package:intl/intl.dart';

class OrderSummary extends StatelessWidget {
  final List<ProductsModel> product;

  const OrderSummary({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    
    double subtotal = product.fold(0, (sum, product) => sum + (product.priceAfterDiscount ?? product.price));
    double vat = subtotal * 0.05;  // Example VAT calculation
    double total = subtotal + vat;

    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin thanh toán",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          SummaryRow(label: "Tạm tính", value: formatCurrency.format(subtotal)),
          const SummaryRow(label: "Phí vận chuyển", value: "Miễn phí", valueColor: Colors.green),
          const Divider(),
          SummaryRow(label: "Tổng tiền", value: formatCurrency.format(total)),
          SummaryRow(label: "Thuế VAT", value: formatCurrency.format(vat)),
        ],
      ),
    );
  }
}