part of 'me_bloc.dart';

class MeState extends Equatable {
  final User me;
  const MeState(this.me);

  @override
  List<Object> get props => [me];

  const MeState._() : me = const User.empty();

  const MeState.meInitial() : this._();
}
