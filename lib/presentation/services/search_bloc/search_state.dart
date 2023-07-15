// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final String sort;
  final int min;
  final int max;
  const SearchState({
    required this.sort,
    required this.min,
    required this.max,
  });

  @override
  List<Object> get props => [sort, min, max];
}

class SearchInitial extends SearchState {
  const SearchInitial({
    required super.sort,
    required super.min,
    required super.max,
  });
}

class SearchLoading extends SearchState {
  const SearchLoading({
    required super.sort,
    required super.min,
    required super.max,
  });
}

class SearchSuccess extends SearchState {
  final List<Product> products;

  const SearchSuccess({
    required super.sort,
    required super.min,
    required super.max,
    required this.products,
  });

  @override
  List<Object> get props => [super.props, products];
}

class SearchFail extends SearchState {
  final String error;

  const SearchFail(
      {required super.sort,
      required super.min,
      required super.max,
      required this.error});
  @override
  List<Object> get props => [super.props, error];
}
