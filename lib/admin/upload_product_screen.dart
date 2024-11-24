// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UploadProductScreen extends StatefulWidget {
//   const UploadProductScreen({super.key});

//   @override
//   _UploadProductScreenState createState() => _UploadProductScreenState();
// }

// class _UploadProductScreenState extends State<UploadProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String title = '';
//   String brandName = '';
//   double price = 0.0;
//   double? priceAfterDiscount;
//   List<String> imageURLs = [];

//   Future<void> uploadProduct() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('products').add({
//         'title': title,
//         'brandName': brandName,
//         'price': price,
//         'priceAfterDiscount': priceAfterDiscount,
//         'imageURL': imageURLs,
//       });
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload Product"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Title'),
//                 onChanged: (value) => title = value,
//                 validator: (value) => value == null || value.isEmpty ? 'Enter a title' : null,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Brand Name'),
//                 onChanged: (value) => brandName = value,
//                 validator: (value) => value == null || value.isEmpty ? 'Enter a brand name' : null,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => price = double.tryParse(value) ?? 0.0,
//                 validator: (value) => value == null || value.isEmpty ? 'Enter a price' : null,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Discounted Price (optional)'),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) => priceAfterDiscount = double.tryParse(value),
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Image URLs (comma-separated)'),
//                 onChanged: (value) => imageURLs = value.split(',').map((e) => e.trim()).toList(),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: uploadProduct,
//                 child: const Text("Upload Product"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
