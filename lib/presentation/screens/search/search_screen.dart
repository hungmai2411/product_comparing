import 'dart:math';

import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:compare_product/presentation/screens/search/components/sort_filter_box.dart';
import 'package:compare_product/presentation/services/search_bloc/search_bloc.dart';
import 'package:compare_product/presentation/widgets/box_search.dart';
import 'package:compare_product/presentation/widgets/item_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: BoxSearch(
                      searchController: searchController,
                      callback: () {},
                      onSubmitted: (s) {
                        context.read<SearchBloc>().add(
                              SearchSubmitted(
                                textSearch: s,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchSuccess) {
                  List<Product> products = state.products;
                  log(products.length);
                  return Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.6,
                            ),
                            itemBuilder: (context, index) {
                              Product product = products[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        product: product,
                                      ),
                                    ),
                                  );
                                },
                                child: ItemProduct(product: product),
                              );
                            },
                            itemCount: products.length,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: SortFilterBox(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is SearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: kTopPadding),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                } else if (state is SearchFail) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
