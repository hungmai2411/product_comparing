part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Product> products;

  const SearchSuccess({required this.products});
  @override
  List<Object> get props => [products];
}

class SearchFail extends SearchState {
  final String error;

  const SearchFail({required this.error});
  @override
  List<Object> get props => [error];
}
