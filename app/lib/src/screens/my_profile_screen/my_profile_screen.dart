import 'dart:developer';

import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/repositorys/repositorys.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'my_profile/my_profile.dart';

const _kLogSource = 'my_profile_screen';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => MyProfileBloc(
            userRepository: context.read<RepositorysCubit>().userRepository,
            authBloc: context.read<AuthBloc>())
          ..add(FetchMyProfile()),
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
          final myProfileState = context.watch<MyProfileBloc>().state;
          return Column(children: [
            _ProfileForm(
              profileName: 'avatar',
              profileWidget: UserAvatar(
                  id: myProfileState.myProfile.id,
                  name: myProfileState.myProfile.name),
              onTap: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 36,
                    maxWidth: 36,
                    requestFullMetadata: false);
                if (pickedImage == null) {
                  log('image not picked');
                  return;
                }
                log('image picked, image mimeType(${pickedImage.mimeType ?? 'null'})');
                final avatar = await userRepository.preSignedAvatarUrl();
                log(
                    name: _kLogSource,
                    'avatar presigned url(${avatar.preSignedUrl})');
                log(
                    name: _kLogSource,
                    'avatar anonymousAccessUrl(${avatar.anonymousAccessUrl})');
                //   final imageBytes = await pickedImage.readAsBytes();
                //   final decodeImage = p_image.decodeImage(imageBytes);
                //   final imageData = p_image.encodePng(decodeImage!);
                //   final imageDataStream = ByteStream.fromBytes(imageData);
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('avatar upload success')));
              },
            ),
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
