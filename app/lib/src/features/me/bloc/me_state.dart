part of 'me_bloc.dart';

@JsonSerializable(explicitToJson: true)
class MeState extends Equatable {
  final Me me;
  const MeState(this.me);

  @override
  List<Object> get props => [me];

  MeState._() : me = Me.empty();
  MeState.meInitial() : this._();
}
