import 'package:compare_product/data/models/notification.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/widgets/box.dart';
import 'package:flutter/material.dart' hide Notification;

class ItemNotification extends StatelessWidget {
  final Notification notification;

  const ItemNotification({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Box(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.width * 0.2,
            child: Image.network(
              notification.image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Easee Notification',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.semibold.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Price has been dropped',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.medium.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Buy Now',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.medium.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          )

          // const SizedBox(height: 5),
        ],
      ),
    );
  }
}
