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

extension Properties on MyProfile {
  String get signature {
    if (data.isEmpty) {
      return "";
    }
    Map<String, dynamic> properties = jsonDecode(data);
    final signature = properties['signature'];
    return signature;
  }
}
