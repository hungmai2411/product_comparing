part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSubmitted extends SearchEvent {
  final String textSearch;

  const SearchSubmitted({required this.textSearch});

  @override
  List<Object> get props => [textSearch];
}

class SortSubmitted extends SearchEvent {
  final String type;

  const SortSubmitted({required this.type});

  @override
  List<Object> get props => [type];
}

class FilterSubmitted extends SearchEvent {
  final int min;
  final int max;

  const FilterSubmitted({
    required this.min,
    required this.max,
  });

  @override
  List<Object> get props => [min, max];
}
