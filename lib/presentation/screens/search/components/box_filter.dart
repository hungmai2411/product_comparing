import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:compare_product/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class BoxFilter extends StatefulWidget {
  const BoxFilter({super.key});

  @override
  State<BoxFilter> createState() => _BoxFilterState();
}

class _BoxFilterState extends State<BoxFilter> {
  RangeValues priceRange = const RangeValues(0, 110000000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter', style: AppStyles.bold.copyWith(fontSize: 21)),
          const SizedBox(height: 10),
          Text(
            'Price Range',
            style: AppStyles.medium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              boxMoney(priceRange.start.round()),
              const SizedBox(width: 10),
              boxMoney(priceRange.end.round()),
            ],
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: RangeSlider(
              min: 0,
              max: 110000000,
              values: priceRange,
              activeColor: AppColors.primary,
              onChanged: (RangeValues values) {
                if (mounted) {
                  setState(() {
                    priceRange = values;
                  });
                }
              },
            ),
          ),
          CustomButton(
            content: 'Submit',
            margin: 0,
            onTap: () {
              Navigator.pop(context, [
                priceRange.start.round(),
                priceRange.end.round(),
              ]);
            },
          ),
        ],
      ),
    );
  }

  Widget boxMoney(int money) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColors.gray,
          ),
        ),
        child: Text(
          money.toMoney,
          textAlign: TextAlign.center,
          style: AppStyles.regular,
        ),
      ),
    );
  }
}
