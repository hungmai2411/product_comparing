part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProductFetched extends ProductEvent {
  final Product product;

  const ProductFetched({required this.product});

  @override
  List<Object> get props => [product];
}
