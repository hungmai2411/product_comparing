import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ReceiveAlertScreen extends StatefulWidget {
  const ReceiveAlertScreen({super.key});

  @override
  State<ReceiveAlertScreen> createState() => _ReceiveAlertScreenState();
}

class _ReceiveAlertScreenState extends State<ReceiveAlertScreen> {
  SfRangeValues priceRange = const SfRangeValues(40.0, 80.0);
  Map<String, bool> values = {
    'Alarm': true,
    'Email': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.3,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.secondary,
          ),
        ),
        title: Text(
          'Set an Alert',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Price Range',
              style: AppStyles.semibold,
            ),
            SfRangeSlider(
              min: 0.0,
              max: 100.0,
              values: priceRange,
              interval: 20,
              activeColor: AppColors.primary,
              //showTicks: true,
              //showLabels: true,
              //enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (SfRangeValues values) {
                setState(() {
                  priceRange = values;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Notify me by',
              style: AppStyles.semibold,
            ),
            ListView(
              shrinkWrap: true,
              children: values.keys.map(
                (String key) {
                  return CheckboxListTile(
                    title: Text(
                      key,
                      style: AppStyles.medium,
                    ),
                    value: values[key],
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        values[key] = value!;
                      });
                    },
                  );
                },
              ).toList(),
            ),
            CustomButton(
              content: 'Done',
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
