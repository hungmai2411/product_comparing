import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductAlert extends StatelessWidget {
  const ProductAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingHorizontal,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price too high?',
                style: AppStyles.semibold.copyWith(
                  fontSize: 14,
                ),
              ),
              RichText(
                text: TextSpan(
                    text: 'Set an Alert',
                    style: AppStyles.semibold.copyWith(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: '  for a price drop.',
                        style: AppStyles.semibold.copyWith(
                          fontSize: 14,
                        ),
                      )
                    ]),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            FontAwesomeIcons.solidBell,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
