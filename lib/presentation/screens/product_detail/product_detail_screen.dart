import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/product_detail/components/item_other_price.dart';
import 'package:compare_product/presentation/screens/product_detail/components/item_technical_info.dart';
import 'package:compare_product/presentation/screens/product_detail/components/product_alert.dart';
import 'package:compare_product/presentation/screens/receive_alert/receive_alert_screen.dart';
import 'package:compare_product/presentation/screens/web_view/web_view_product_screen.dart';
import 'package:compare_product/presentation/services/product_bloc/product_bloc.dart';
import 'package:compare_product/presentation/utils/money_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductFetched(product: widget.product));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: kPaddingHorizontal),
              child: Icon(
                Icons.favorite_border_outlined,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadedSuccess) {
            Product newProduct = state.newProduct;

            return SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FlutterCarousel(
                    //   options: CarouselOptions(
                    //     height: size.height * 0.3,
                    //     viewportFraction: 1.0,
                    //     enlargeCenterPage: false,
                    //     autoPlay: true,
                    //     enableInfiniteScroll: true,
                    //     autoPlayInterval: const Duration(seconds: 2),
                    //     slideIndicator: CircularWaveSlideIndicator(),
                    //   ),
                    //   items: newProduct.images!
                    //       .map((e) => Image.network(
                    //             e,
                    //             fit: BoxFit.fitWidth,
                    //           ))
                    //       .toList(),
                    // ),
                    Center(
                      child: SizedBox(
                        height: size.height * 0.3,
                        child: Image.network(
                          newProduct.imgUrl!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        newProduct.name!,
                        style: AppStyles.semibold,
                      ),
                    ),
                    if (newProduct.discountPrice != 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          newProduct.discountPrice!.toMoney,
                          style:
                              AppStyles.bold.copyWith(color: AppColors.primary),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        newProduct.originalPrice!.toMoney,
                        style: newProduct.discountPrice == 0
                            ? AppStyles.bold.copyWith(color: AppColors.primary)
                            : AppStyles.medium.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.gray,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Compare Price',
                            style: AppStyles.bold,
                          ),
                          Text(
                            'See All',
                            style: AppStyles.bold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.otherPrices.isNotEmpty)
                      ...state.otherPrices.map(
                        (e) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    WebViewProductScreen(url: e!['url']),
                              ),
                            );
                          },
                          child: ItemOtherPrice(
                            result: e,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReceiveAlertScreen(),
                            ),
                          );
                        },
                        child: const ProductAlert(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Features & Details',
                        style: AppStyles.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          List<String> props =
                              newProduct.technicalInfo!.keys.toList();
                          List<String> descriptions =
                              newProduct.technicalInfo!.values.toList();
                          return ItemTechnicalInfo(
                            prop: props[index],
                            description: descriptions[index],
                            index: index,
                          );
                        },
                        itemCount: newProduct.technicalInfo!.length,
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is ProductLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: kTopPadding),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            );
          } else if (state is ProductError) {
            return Center(
              child: Text(state.error),
            );
          }
          return Container();
        },
      ),
    );
  }
}
