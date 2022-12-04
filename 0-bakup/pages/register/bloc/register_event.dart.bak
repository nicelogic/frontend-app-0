import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FocusMailFieldEvent extends RegisterEvent {}

class NotifyMailAddrIsValieEvent extends RegisterEvent {
  final bool _isValid;
  bool get isValid => _isValid;

  NotifyMailAddrIsValieEvent(final bool isValid) : _isValid = isValid;
}
