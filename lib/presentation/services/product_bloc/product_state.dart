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
  const ProductLoadedSuccess({
    required this.newProduct,
    required this.otherPrices,
  });

  @override
  List<Object> get props => [newProduct, otherPrices];
}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String error;
  const ProductError({required this.error});

  @override
  List<Object> get props => [error];
}
