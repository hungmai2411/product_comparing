import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:flutter/material.dart';

class ItemChip extends StatelessWidget {
  final String content;
  final bool isSelected;
  final Function(String) callback;

  const ItemChip({
    super.key,
    required this.content,
    required this.isSelected,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callback(content);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: !isSelected ? const Color(0xFFF6F6F6) : AppColors.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: AppStyles.semibold,
        ),
      ),
    );
  }
}
