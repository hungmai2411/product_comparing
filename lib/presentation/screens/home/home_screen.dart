import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/search/search_screen.dart';
import 'package:compare_product/presentation/screens/voucher/components/item_voucher.dart';
import 'package:compare_product/presentation/screens/web_view/web_view_voucher_screen.dart';
import 'package:compare_product/presentation/services/voucher_bloc/voucher_bloc.dart';
import 'package:compare_product/presentation/widgets/box_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  VoucherBloc get _bloc => BlocProvider.of<VoucherBloc>(context);

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(VoucherStartedAtHome());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Easee Buy',
                  style: AppStyles.semibold.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            GestureDetector(
              child: const Icon(
                FontAwesomeIcons.bell,
                color: AppColors.secondary,
              ),
            )
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingHorizontal),
                  child: BoxSearch(
                    searchController: searchController,
                    callback: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SearchScreen(),
                        ),
                      );
                    },
                    onSubmitted: (s) {},
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Offers you can\'t resist',
                  style: AppStyles.semibold.copyWith(
                    fontSize: 18,
                    color: AppColors.box,
                  ),
                ),
                Expanded(
                  child: BlocBuilder<VoucherBloc, VoucherState>(
                    builder: (context, state) {
                      if (state is VoucherSuccess) {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
