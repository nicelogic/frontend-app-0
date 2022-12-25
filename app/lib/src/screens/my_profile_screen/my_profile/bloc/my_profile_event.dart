part of 'my_profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchMyProfile extends MyProfileEvent {}

class UpdateAvatarUrl extends MyProfileEvent {
  final String anonymousAccessUrl;

  const UpdateAvatarUrl(this.anonymousAccessUrl);
}
