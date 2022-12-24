import 'dart:developer';

import 'package:app/src/configs/configs.dart';
import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:http/http.dart' as http;
import 'my_profile/my_profile.dart' as my_profile;
import 'package:image/image.dart' as image_util;

const _kLogSource = 'my_profile_screen';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => my_profile.MyProfileBloc(
            userRepository: context.read<RepositorysCubit>().userRepository,
            authBloc: context.read<AuthBloc>())
          ..add(my_profile.FetchMyProfile()),
        child: _MyProfileScreen());
  }
}

class _MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<RepositorysCubit>().userRepository;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text('My Profile'),
        ),
        body: Builder(builder: ((context) {
          final myProfileState =
              context.watch<my_profile.MyProfileBloc>().state;
          return Column(children: [
            _ProfileForm(
                profileName: 'avatar',
                profileWidget: UserAvatar(
                  id: myProfileState.myProfile.id,
                  name: myProfileState.myProfile.name,
                  avatarUrl: myProfileState.myProfile.avatarUrl,
                ),
                onTap: () => _onTapAvatarProfileForm(userRepository)),
            _ProfileForm(
                profileName: 'name',
                profileWidget: Text(myProfileState.myProfile.name),
                onTap: () {
                  // context.router.push(EditPersonProfileRoute(
                  //     inputLabel: Config.instance().pleaseInputNewName,
                  //     accountJsonKey: kName));
                }),
            _ProfileForm(
              profileName: 'id',
              profileWidget: Text(myProfileState.myProfile.id),
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('id can not change')));
              },
            ),
            _ProfileForm(
              profileName: 'signature',
              profileWidget: Text(myProfileState.myProfile.signature),
              onTap: () {
                // context.router.push(EditPersonProfileRoute(
                //     inputLabel: Config.instance().pleaseInputNewSignature,
                //     accountJsonKey: kSignature));
              },
            )
          ]);
        })));
  }

  void _onTapAvatarProfileForm(
      user_repository.UserRepository userRepository) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: Config.instance().profilePictureMaxHeight,
          maxWidth: Config.instance().profilePictureMaxWidth,
          requestFullMetadata: false);
      if (pickedImage == null) {
        log(name: _kLogSource, 'image not picked');
        return;
      }
      final avatar = await userRepository.preSignedAvatarUrl();
      if (avatar.error != user_repository.UserError.none) {
        log(name: _kLogSource, 'presigned avatar url error(${avatar.error})');
        return;
      }
      log(name: _kLogSource, 'avatar presigned url(${avatar.preSignedUrl})');
      log(
          name: _kLogSource,
          'avatar anonymousAccessUrl(${avatar.anonymousAccessUrl})');
      log(name: _kLogSource, 'picked image name(${pickedImage.name}');
      final bool isPng = pickedImage.name.endsWith('.png');
      var imageBytes = await pickedImage.readAsBytes();
      if (!isPng) {
        log(name: _kLogSource, 'not png, will convert to png');
        final decodeImage = image_util.decodeImage(imageBytes);
        imageBytes = Uint8List.fromList(image_util.encodePng(decodeImage!));
      }
      final response = await http.put(Uri.parse(avatar.preSignedUrl),
          body: imageBytes);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(name: _kLogSource, 'response code(${response.statusCode}');
        final user = await userRepository.updateUser(properties: {
          user_repository.kAvatarUrl: avatar.anonymousAccessUrl
        });
        log(
            name: _kLogSource,
            'update user(${user.id}), avatar url(${user.avatarUrl})');
      } else {
        log(
            name: _kLogSource,
            'put avatar to s3 error, response code(${response.statusCode}');
        //tip user, upload failure
        return;
      }
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
  }
}

class _ProfileForm extends StatelessWidget {
  final String profileName;
  final Widget profileWidget;
  final VoidCallback? onTap;

  const _ProfileForm(
      {Key? key,
      this.profileName = '',
      this.profileWidget = const Text(''),
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
            child: Container(
                padding: const EdgeInsets.fromLTRB(1, 20, 15, 20),
                child: Row(children: <Widget>[
                  const SizedBox(width: 20),
                  Text(profileName),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[profileWidget])),
                  const SizedBox(width: 10),
                  const Icon(Icons.chevron_right)
                ]))));
  }
}
