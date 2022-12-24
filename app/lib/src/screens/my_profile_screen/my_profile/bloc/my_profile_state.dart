part of 'my_profile_bloc.dart';

@JsonSerializable(explicitToJson: true)
class MyProfileState extends Equatable {
  final MyProfile myProfile;

  @override
  List<Object> get props => [myProfile];

  const MyProfileState({required this.myProfile});
  const MyProfileState.myProfileInitial()
      : this(myProfile: const MyProfile.empty());
}
