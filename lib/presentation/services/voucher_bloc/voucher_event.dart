part of 'voucher_bloc.dart';

abstract class VoucherEvent extends Equatable {
  const VoucherEvent();

  @override
  List<Object> get props => [];
}

class VoucherStarted extends VoucherEvent {}

class VoucherStartedAtHome extends VoucherEvent {}
