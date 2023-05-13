// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoadedSuccess extends ProductState {
  final Product newProduct;
  final List<Map<String, dynamic>?> otherPrices;
  final bool isLoved;

  const ProductLoadedSuccess({
    required this.newProduct,
    required this.otherPrices,
    required this.isLoved,
  });

  @override
  List<Object> get props => [
        newProduct,
        otherPrices,
        isLoved,
      ];

  ProductLoadedSuccess copyWith({
    Product? newProduct,
    List<Map<String, dynamic>?>? otherPrices,
    bool? isLoved,
  }) {
    return ProductLoadedSuccess(
      newProduct: newProduct ?? this.newProduct,
      otherPrices: otherPrices ?? this.otherPrices,
      isLoved: isLoved ?? this.isLoved,
    );
  }
}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String error;
  const ProductError({required this.error});

  @override
  List<Object> get props => [error];
}
