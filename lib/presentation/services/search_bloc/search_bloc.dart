import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/product.dart';
import 'package:compare_product/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository productRepository;

  List<Product> products = [];

  String sort = 'Lowest Price';
  int min = 0;
  int max = 110000000;

  SearchBloc(this.productRepository)
      : super(const SearchInitial(
          sort: 'Lowest Price',
          min: 0,
          max: 110000000,
        )) {
    on<SearchSubmitted>(_onSearched);
    on<SortSubmitted>(_onSorted);
    on<FilterSubmitted>(_onFiltered);
  }

  FutureOr<void> _onSearched(event, emit) async {
    emit(SearchLoading(
      sort: sort,
      min: min,
      max: max,
    ));

    try {
      List<Product> result =
          await productRepository.searchProduct(event.textSearch);

      products = result;

      emit(SearchSuccess(
        products: products,
        sort: sort,
        min: min,
        max: max,
      ));
    } catch (e) {
      emit(SearchFail(
        error: e.toString(),
        sort: sort,
        min: min,
        max: max,
      ));
    }
  }

  FutureOr<void> _onSorted(SortSubmitted event, Emitter<SearchState> emit) {
    sort = event.type;
    emit(SearchLoading(
      sort: sort,
      min: min,
      max: max,
    ));
    if (event.type == 'Lowest Price') {
      products.sort((product1, product2) {
        int tmp1, tmp2 = 0;

        tmp1 = product1.discountPrice == 0
            ? product1.originalPrice!
            : product1.discountPrice!;
        tmp2 = product2.discountPrice == 0
            ? product2.originalPrice!
            : product2.discountPrice!;

        return tmp1.compareTo(tmp2);
      });
    } else {
      products.sort((product1, product2) {
        int tmp1, tmp2 = 0;

        tmp1 = product1.discountPrice == 0
            ? product1.originalPrice!
            : product1.discountPrice!;
        tmp2 = product2.discountPrice == 0
            ? product2.originalPrice!
            : product2.discountPrice!;

        return tmp2.compareTo(tmp1);
      });
    }

    emit(SearchSuccess(
      products: [
        ...products,
      ],
      sort: sort,
      min: min,
      max: max,
    ));
  }

  FutureOr<void> _onFiltered(
      FilterSubmitted event, Emitter<SearchState> emit) async {
    min = event.min;
    max = event.max;
    List<Product> tmp = [];

    for (var element in products) {
      int price = 0;

      price = element.discountPrice == 0
          ? element.originalPrice!
          : element.discountPrice!;
      if (price >= event.min && price <= event.max) {
        tmp.add(element);
      }
    }

    emit(SearchSuccess(
      products: [...tmp],
      sort: sort,
      min: min,
      max: max,
    ));
  }
}
