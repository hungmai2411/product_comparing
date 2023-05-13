import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:compare_product/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BoxFilter extends StatefulWidget {
  const BoxFilter({super.key});

  @override
  State<BoxFilter> createState() => _BoxFilterState();
}

class _BoxFilterState extends State<BoxFilter> {
  SfRangeValues priceRange = const SfRangeValues(0, 110000000);

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
          Row(
            children: [
              boxMoney(
                priceRange.start,
              ),
              boxMoney(
                priceRange.end,
              ),
            ],
          ),
          SizedBox(
            height: 50,
            child: SfRangeSlider(
              min: 0,
              max: 110000000,
              values: priceRange,
              interval: 20,
              activeColor: AppColors.primary,
              //showTicks: true,
              //showLabels: true,
              //enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (SfRangeValues values) {
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget boxMoney(int money) {
    return Expanded(
      child: Container(
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
