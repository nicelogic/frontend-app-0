part of 'me_bloc.dart';

@JsonSerializable(explicitToJson: true)
class MeState extends Equatable {
  final Me me;

  @override
  List<Object> get props => [me];

  const MeState({required this.me});
  const MeState.meInitial() : this(me: const Me.empty());
}

extension Properties on Me {
  String get signature {
    Map<String, dynamic> properties = jsonDecode(data);
    final signature = properties['signature'];
    return signature;
  }
}
