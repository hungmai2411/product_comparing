import 'package:compare_product/presentation/res/style.dart';
import 'package:flutter/material.dart';

class ItemTechnicalInfo extends StatelessWidget {
  final String prop;
  final String description;
  final int index;

  const ItemTechnicalInfo({
    super.key,
    required this.prop,
    required this.description,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xFFF6F6F6),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              prop,
              style: AppStyles.regular,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: AppStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
