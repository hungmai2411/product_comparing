import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<ProductFetched>((event, emit) async {
      try {
        emit(ProductLoading());

        Product newProduct =
            await productRepository.getDetailProductAtGearVN(event.product);

        log('name product: ${newProduct.name}');

        List<Map<String, dynamic>?> otherPrices = [];

        Map<String, dynamic>? priceFromPhongVu =
            await productRepository.getPriceFromPhongVu(event.product.name!);

        Map<String, dynamic>? priceFromHoangHa =
            await productRepository.getPriceFromHoangHa(event.product.name!);

        otherPrices.add(priceFromPhongVu);
        otherPrices.add(priceFromHoangHa);

        emit(
          ProductLoadedSuccess(
            newProduct: newProduct,
            otherPrices: otherPrices,
          ),
        );
      } catch (e) {
        emit(ProductError(error: e.toString()));
      }
    });
  }
}
