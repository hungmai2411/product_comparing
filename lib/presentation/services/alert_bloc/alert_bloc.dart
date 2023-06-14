import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:compare_product/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final ProductRepository _productRepository;
  AlertBloc(this._productRepository) : super(AlertInitial()) {
    on<AlertSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onSubmitted(
      AlertSubmitted event, Emitter<AlertState> emit) async {
    emit(AlertLoading());

    try {
      await _productRepository.orderProduct(
        event.link,
        event.mail,
        event.min,
        event.max,
      );
      emit(AlertSuccess());
    } catch (e) {
      emit(AlertFailure(errorMessage: e.toString()));
    }
  }
}
