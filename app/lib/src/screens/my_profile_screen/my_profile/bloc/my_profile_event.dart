part of 'my_profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();

  @override
  List<Object> get props => [];
}

class _UnAuthenticated extends MyProfileEvent {}

class FetchMyProfile extends MyProfileEvent {}
