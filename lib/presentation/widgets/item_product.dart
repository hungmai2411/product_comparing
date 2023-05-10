import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';

class ItemProduct extends StatelessWidget {
  final Product product;

  const ItemProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Box(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.width * 0.5,
            child: Image.network(
              product.imgUrl!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            product.name.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.semibold.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          if (product.discountPrice != 0)
            Text(
              product.discountPrice!.toMoney,
              style: AppStyles.bold.copyWith(
                fontSize: 13,
              ),
            ),
          Text(
            product.originalPrice!.toMoney,
            style: product.discountPrice == 0
                ? AppStyles.bold.copyWith(
                    fontSize: 14,
                  )
                : AppStyles.regular.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.gray,
                    fontSize: 12,
                  ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.gray,
                size: 15,
              ),
              Text(
                product.shopName!,
                style: AppStyles.regular.copyWith(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int parseTextPrice(String price) {
    int index = price.indexOf("₫");
    price = price.substring(0, index - 1);
    return int.parse(price.replaceAll('.', ''));
  }

  String countSaved(String originalPrice, String discountPrice) {
    int original = parseTextPrice(originalPrice);
    int discount = parseTextPrice(discountPrice);

    int saved = original - discount;
    String savedFormatted = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(saved);

    return savedFormatted;
  }
}
