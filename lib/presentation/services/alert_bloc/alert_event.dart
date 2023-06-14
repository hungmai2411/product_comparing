part of 'alert_bloc.dart';

abstract class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

class AlertSubmitted extends AlertEvent {
  final String link;
  final String mail;
  final int min;
  final int max;

  const AlertSubmitted({
    required this.link,
    required this.mail,
    required this.max,
    required this.min,
  });

  @override
  List<Object> get props => [link, mail, min, max];
}
