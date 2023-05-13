import 'dart:developer';

import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/images.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/search/components/box_filter.dart';
import 'package:compare_product/presentation/screens/search/components/box_sort.dart';
import 'package:compare_product/presentation/services/search_bloc/search_bloc.dart';
import 'package:compare_product/presentation/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SortFilterBox extends StatelessWidget {
  const SortFilterBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            color: const Color(0xFFBABABA).withOpacity(
              0.5,
            ),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            itemSortFilter(
              AppAssets.icFilter,
              'Filter',
              () => openFilterDialog(context),
            ),
            const SizedBox(width: 10),
            const VerticalDivider(
              color: AppColors.gray,
            ),
            const SizedBox(width: 10),
            itemSortFilter(
              AppAssets.icSort,
              'Sort',
              () => openSortDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void openSortDialog(BuildContext context) async {
    final result = await showBottomDialog(
      context,
      const BoxSort(),
    );

    if (result != null) {
      context.read<SearchBloc>().add(SortSubmitted(type: result));
    }
  }

  void openFilterDialog(BuildContext context) async {
    try {
      final result = await showBottomDialog(
        context,
        const BoxFilter(),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Widget itemSortFilter(String image, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            image,
            width: 25,
            height: 25,
            color: AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(name, style: AppStyles.regular),
        ],
      ),
    );
  }
}
