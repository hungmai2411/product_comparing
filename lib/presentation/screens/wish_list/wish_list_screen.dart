import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/presentation/res/colors.dart';
import 'package:compare_product/presentation/res/dimensions.dart';
import 'package:compare_product/presentation/res/style.dart';
import 'package:compare_product/presentation/screens/web_view/web_view_product_screen.dart';
import 'package:compare_product/presentation/screens/wish_list/components/item_wishlist.dart';
import 'package:compare_product/presentation/services/wishlist_bloc/wishlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  WishlistBloc get _bloc => BlocProvider.of<WishlistBloc>(context);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(const WishlistFetched());
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
            Align(
              alignment: Alignment.center,
              child: Text(
                'My Wishlist',
                style: AppStyles.semibold.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                if (state is WishlistSuccess) {
                  List<Wishlist> wishlists = state.wishlists;

                  return Padding(
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
                        Wishlist wishlist = wishlists[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    WebViewProductScreen(url: wishlist.url),
                              ),
                            );
                          },
                          child: ItemWishlist(wishlist: wishlist),
                        );
                      },
                      itemCount: wishlists.length,
                    ),
                  );
                } else if (state is WishlistLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: kTopPadding),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                } else if (state is WishlistFailed) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
