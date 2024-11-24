import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, entryPointScreenRoute),
          icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text('Giỏ hàng (0)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black54,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'GIỎ HÀNG CỦA BẠN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Giỏ hàng của bạn đang trống',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, entryPointScreenRoute);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('TIẾP TỤC MUA HÀNG'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(0, 0),
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}