import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:flutter/material.dart';

class ItemVoucher extends StatelessWidget {
  final Voucher voucher;

  const ItemVoucher({
    super.key,
    required this.voucher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: const Color(0xFFBABABA).withOpacity(0.1325),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (voucher.thumbnail.isNotEmpty) Image.network(voucher.thumbnail),
          Text(
            voucher.title,
            style: AppStyles.semibold.copyWith(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
