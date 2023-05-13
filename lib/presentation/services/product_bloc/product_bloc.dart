import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/data/models/wishlist.dart';
import 'package:compare_product/data/repository/product_repository.dart';
import 'package:compare_product/data/repository/wishlist_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  final WishlistRepository wishlistRepository;

  // data
  late Product newProduct;
  late List<Map<String, dynamic>?> otherPrices;
  late bool isLoved;

  ProductBloc(
    this.productRepository,
    this.wishlistRepository,
  ) : super(ProductInitial()) {
    on<ProductFetched>(_onFetched);
    on<ProductLoved>(_onLoved);
  }

  FutureOr<void> _onFetched(event, emit) async {
    try {
      emit(ProductLoading());

      newProduct =
          await productRepository.getDetailProductAtGearVN(event.product);

      log('name product: ${newProduct.name}');

      otherPrices = [];

      Map<String, dynamic>? priceFromPhongVu =
          await productRepository.getPriceFromPhongVu(event.product.name!);

      Map<String, dynamic>? priceFromHoangHa =
          await productRepository.getPriceFromHoangHa(event.product.name!);

      otherPrices.add(priceFromPhongVu);
      otherPrices.add(priceFromHoangHa);

      isLoved = await wishlistRepository.isLoved(newProduct.name!);

      emit(
        ProductLoadedSuccess(
          newProduct: newProduct,
          otherPrices: otherPrices,
          isLoved: isLoved,
        ),
      );
    } catch (e) {
      emit(ProductError(error: e.toString()));
    }
  }

  FutureOr<void> _onLoved(
      ProductLoved event, Emitter<ProductState> emit) async {
    if (isLoved) {
      wishlistRepository.deleteWishlist(event.wishlist.name);
    } else {
      await wishlistRepository.addWishlist(event.wishlist);
    }
    isLoved = !isLoved;
    emit(
      ProductLoadedSuccess(
        newProduct: newProduct,
        otherPrices: otherPrices,
        isLoved: isLoved,
      ),
    );
  }
}
