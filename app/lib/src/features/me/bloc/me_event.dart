part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object> get props => [];
}

class _MeFetched extends MeEvent {
  final Me me;
  const _MeFetched(this.me);
}

class _UnAuthenticated extends MeEvent {}
