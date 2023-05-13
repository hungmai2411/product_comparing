import 'package:compare_product/presentation/screens/product_detail/components/item_technical_info.dart';
import 'package:flutter/material.dart';

class FeatureDetails extends StatelessWidget {
  final Map<String, String> technicalInfo;

  const FeatureDetails({super.key, required this.technicalInfo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: false,
        itemBuilder: (context, index) {
          List<String> props = technicalInfo.keys.toList();
          List<String> descriptions = technicalInfo.values.toList();
          return ItemTechnicalInfo(
            prop: props[index],
            description: descriptions[index],
            index: index,
          );
        },
        itemCount: technicalInfo.length,
      ),
    );
  }
}
