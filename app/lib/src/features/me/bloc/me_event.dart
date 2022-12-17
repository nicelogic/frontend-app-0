part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object> get props => [];
}

class _MeFetched extends MeEvent {
  final User me;
  const _MeFetched(this.me);
}

class _Logout extends MeEvent {}
