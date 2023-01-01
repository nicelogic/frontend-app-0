part of 'me_bloc.dart';

abstract class MeEvent extends Equatable {
  const MeEvent();

  @override
  List<Object> get props => [];
}

class FetchMe extends MeEvent {}

class UpdateAvatarUrl extends MeEvent {
  final String anonymousAccessUrl;
  const UpdateAvatarUrl(this.anonymousAccessUrl);
}

class UpdateName extends MeEvent {
  final String name;
  const UpdateName(this.name);
}
