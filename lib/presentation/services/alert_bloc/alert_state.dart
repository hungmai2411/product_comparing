part of 'alert_bloc.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertSuccess extends AlertState {}

class AlertFailure extends AlertState {
  final String errorMessage;

  const AlertFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
