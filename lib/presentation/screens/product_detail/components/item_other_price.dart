import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:flutter/material.dart';

class ItemOtherPrice extends StatelessWidget {
  final Map<String, dynamic>? result;

  const ItemOtherPrice({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration:
                          const BoxDecoration(color: AppColors.secondary),
                      child: Center(
                        child: Text(
                          (result!['price'] as int).toMoney,
                          style: AppStyles.semibold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          result!['place'],
                          style: AppStyles.semibold.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(width: 30),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20,
          )
        ],
      ),
    );
  }
}
