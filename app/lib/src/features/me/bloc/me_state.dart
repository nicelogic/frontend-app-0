part of 'me_bloc.dart';

abstract class MeState extends Equatable {
  final User me;
  const MeState(this.me);

  @override
  List<Object> get props => [];
}

class MeInitial extends MeState {
  const MeInitial() : super(const User.empty());
}

class Me extends MeState {
  const Me(super.user);
}
