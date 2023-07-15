import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:compare_product/data/models/notification.dart';
import 'package:compare_product/data/models/voucher.dart';
import 'package:compare_product/data/repository/notification_repository.dart';
import 'package:compare_product/data/repository/voucher_repository.dart';
import 'package:equatable/equatable.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;
  final NotificationRepository _notificationRepository;

  List<Notification> notifications = [];

  VoucherBloc(
    this._voucherRepository,
    this._notificationRepository,
  ) : super(VoucherInitial()) {
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

      emit(
        VoucherSuccess(
          vouchers: [...vouchersFromGearVN, ...vouchersFromPhongVu],
          notifications: [...notifications],
        ),
      );
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

      List<Notification> result =
          await _notificationRepository.getNotifications();

      emit(VoucherSuccess(
        vouchers: [...vouchersFromPhongVu],
        notifications: [...result],
      ));
    } catch (e) {
      emit(VoucherFailure(errorMessage: e.toString()));
    }
  }
}
