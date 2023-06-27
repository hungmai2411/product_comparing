import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/data/repository/voucher_repository.dart';
import 'package:equatable/equatable.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherBloc(this._voucherRepository) : super(VoucherInitial()) {
    on<VoucherStarted>(_onStarted);
    on<VoucherStartedAtHome>(_onStartedAtHome);
  }

  FutureOr<void> _onStarted(
      VoucherStarted event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      List<Voucher> vouchersFromGearVN =
          await _voucherRepository.getVouchersAtGearVN();
      List<Voucher> vouchersFromPhongVu =
          await _voucherRepository.getVouchersAtPhongVu();

      emit(VoucherSuccess(
          vouchers: [...vouchersFromPhongVu, ...vouchersFromGearVN]));
    } catch (e) {
      emit(VoucherFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onStartedAtHome(
      VoucherStartedAtHome event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    try {
      List<Voucher> vouchersFromPhongVu =
          await _voucherRepository.getVouchersAtPhongVu();

      emit(VoucherSuccess(vouchers: [...vouchersFromPhongVu]));
    } catch (e) {
      emit(VoucherFailure(errorMessage: e.toString()));
    }
  }
}
