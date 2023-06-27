import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/presentation/helper/loading/loading_screen.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/voucher/components/item_voucher.dart';
import 'package:compare_product/presentation/screens/web_view/web_view_voucher_screen.dart';
import 'package:compare_product/presentation/services/voucher_bloc/voucher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  VoucherBloc get _bloc => BlocProvider.of<VoucherBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(VoucherStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.3,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Vouchers',
            style: AppStyles.semibold.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: BlocBuilder<VoucherBloc, VoucherState>(
        builder: (context, state) {
          if (state is VoucherLoading) {
            return LoadingScreen().showLoadingWidget();
          } else if (state is VoucherSuccess) {
            List<Voucher> vouchers = state.vouchers;

            return ListView.builder(
              itemBuilder: (context, index) {
                Voucher voucher = vouchers[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WebViewVoucherScreen(
                          url: voucher.link,
                        ),
                      ),
                    );
                  },
                  child: ItemVoucher(voucher: voucher),
                );
              },
              itemCount: vouchers.length,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
