import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/services/search_bloc/search_bloc.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:compare_product/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoxFilter extends StatefulWidget {
  const BoxFilter({super.key});

  @override
  State<BoxFilter> createState() => _BoxFilterState();
}

class _BoxFilterState extends State<BoxFilter> {
  RangeValues priceRange = const RangeValues(0, 110000000);
  late RangeValues selectedPriceRange;

  SearchBloc get _bloc => BlocProvider.of<SearchBloc>(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedPriceRange =
        RangeValues(_bloc.min.toDouble(), _bloc.max.toDouble());
  }

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
              boxMoney(selectedPriceRange.start.round()),
              const SizedBox(width: 10),
              boxMoney(selectedPriceRange.end.round()),
            ],
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: RangeSlider(
              min: 0,
              max: 110000000,
              values: selectedPriceRange,
              activeColor: AppColors.primary,
              onChanged: (RangeValues values) {
                if (mounted) {
                  setState(() {
                    selectedPriceRange = values;
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
                selectedPriceRange.start.round(),
                selectedPriceRange.end.round(),
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
