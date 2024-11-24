import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../constants.dart';
import 'package:shop/route/screen_export.dart';

class ExpansionCategory extends StatelessWidget {
  const ExpansionCategory({
    super.key,
    required this.title,
    required this.subCategory,
    required this.categoryId,
  });

  final String title;
  final String categoryId; // Used for Firestore query
  final List subCategory;

  void _onSubCategoryPressed(BuildContext context, String subCategoryTitle) {
    // Determine the query based on the subcategory title
    final Map<String, Map<String, dynamic>> queryMappings = {
      "Tất cả sản phẩm": {"field": "categoryId", "value": categoryId},
      "Tất - Vớ": {"field": "isSock", "value": true},
      "Balo - Túi xách": {"field": "isBagpack", "value": true},
      "Mũ - Nón": {"field": "isHat", "value": true},
      "Áo thun nam": {"field": "isManShirt", "value": true},
      "Quần nam": {"field": "isManPant", "value": true},
      "Áo khoác nam": {"field": "isManJacket", "value": true},
      "Áo thun nữ": {"field": "isWomanShirt", "value": true},
      "Quần nữ": {"field": "isWomanPants", "value": true},
      "Áo khoác nữ": {"field": "isWomanJacket", "value": true},
    };

    Query<Map<String, dynamic>> query;

    if (queryMappings.containsKey(subCategoryTitle)) {
      // Use the mapping to dynamically build the query
      final field = queryMappings[subCategoryTitle]!['field'] as String;
      final value = queryMappings[subCategoryTitle]!['value'];
      query = FirebaseFirestore.instance
          .collection('Products')
          .where(field, isEqualTo: value);
    } else {
      // Default case: for other subcategories
      query = FirebaseFirestore.instance
          .collection('Products')
          .where('subCategories', isEqualTo: subCategoryTitle);
    }

    Navigator.pushNamed(
      context,
      onSaleScreenRoute,
      arguments: query,
    );
    debugPrint(
        'Querying Firestore with: subCategoryTitle = $subCategoryTitle, categoryId = $categoryId');
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      textColor: Theme.of(context).textTheme.bodyLarge!.color,
      childrenPadding: const EdgeInsets.only(left: defaultPadding * 3.5),
      children: List.generate(
        subCategory.length,
        (index) => Column(
          children: [
            ListTile(
              onTap: () => _onSubCategoryPressed(context, subCategory[index]),
              title: Text(
                subCategory[index],
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (index < subCategory.length - 1) const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
