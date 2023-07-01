import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/product_detail/components/feature_details.dart';
import 'package:compare_product/presentation/screens/product_detail/components/item_chip.dart';
import 'package:compare_product/presentation/screens/product_detail/components/item_other_price.dart';
import 'package:compare_product/presentation/screens/product_detail/components/price_history.dart';
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
  String contentChip = "Features & Details";
  List<String> chipContents = [
    "Compare Price",
    "Features & Details",
    "Price History",
  ];

  ProductBloc get _bloc => BlocProvider.of<ProductBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(ProductFetched(product: widget.product));
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
            onTap: loveProduct,
            child: Padding(
              padding: const EdgeInsets.only(right: kPaddingHorizontal),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadedSuccess) {
                    if (state.isLoved) {
                      return const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primary,
                      );
                    } else {
                      return const Icon(
                        Icons.favorite_border_outlined,
                        color: AppColors.primary,
                      );
                    }
                  }
                  return const Icon(
                    Icons.favorite_border_outlined,
                    color: AppColors.primary,
                  );
                },
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ReceiveAlertScreen(
                                link: widget.product.url!,
                              ),
                            ),
                          );
                        },
                        child: const ProductAlert(),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                      child: Divider(color: AppColors.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          ...chipContents.map(
                            (e) => Expanded(
                              child: ItemChip(
                                content: e,
                                isSelected: contentChip == e,
                                callback: (content) {
                                  setState(() {
                                    contentChip = content;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (contentChip == 'Features & Details')
                      newProduct.technicalInfo == null
                          ? const SizedBox()
                          : FeatureDetails(
                              technicalInfo: newProduct.technicalInfo!)
                    else if (contentChip == 'Compare Price')
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
                      )
                    else
                      PriceHistory(
                        numOfDays: 31,
                        prices: state.newProduct.prices!,
                        month: 7,
                      ),
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

  void loveProduct() {
    Wishlist wishlist = Wishlist(
      url: widget.product.url!,
      image: widget.product.imgUrl!,
      name: widget.product.name!,
    );
    _bloc.add(ProductLoved(wishlist: wishlist));
  }
}
