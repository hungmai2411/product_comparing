import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/widgets/box.dart';
import 'package:flutter/material.dart';

class ItemWishlist extends StatelessWidget {
  final Wishlist wishlist;

  const ItemWishlist({super.key, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Box(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.width * 0.5,
            child: Image.network(
              wishlist.image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            wishlist.name.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.semibold.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          // if (product.discountPrice != 0)
          //   Text(
          //     product.discountPrice!.toMoney,
          //     style: AppStyles.bold.copyWith(
          //       fontSize: 13,
          //     ),
          //   ),
          // Text(
          //   product.originalPrice!.toMoney,
          //   style: product.discountPrice == 0
          //       ? AppStyles.bold.copyWith(
          //           fontSize: 14,
          //         )
          //       : AppStyles.regular.copyWith(
          //           decoration: TextDecoration.lineThrough,
          //           color: AppColors.gray,
          //           fontSize: 12,
          //         ),
          // ),
          //const Spacer(),
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.location_on_outlined,
          //       color: AppColors.gray,
          //       size: 15,
          //     ),
          //     Text(
          //       product.shopName!,
          //       style: AppStyles.regular.copyWith(fontSize: 13),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
