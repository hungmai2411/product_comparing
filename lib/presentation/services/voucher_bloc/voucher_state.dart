part of 'voucher_bloc.dart';

abstract class VoucherState extends Equatable {
  const VoucherState();

  @override
  List<Object> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherFailure extends VoucherState {
  final String errorMessage;

  const VoucherFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class VoucherSuccess extends VoucherState {
  final List<Voucher> vouchers;
  final List<Notification> notifications;

  const VoucherSuccess({
    required this.vouchers,
    required this.notifications,
  });

  @override
  List<Object> get props => [vouchers, notifications];
}
