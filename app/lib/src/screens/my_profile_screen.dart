import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/widgets/widgets.dart' as widgets;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:app/src/configs/configs.dart' as configs;
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:app/src/features/me/me.dart' as me;
import 'package:app/src/features/my_profile/my_profile.dart' as my_profile;
import 'package:app/src/features/repositorys/repositorys.dart' as repositorys;
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image_util;

const _kLogSource = 'my_profile_screen';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (_) => me.MeBloc(
              userRepository:
                  context.read<repositorys.RepositorysCubit>().userRepository,
              authBloc: context.read<auth.AuthBloc>())
            ..add(me.FetchMe())),
      BlocProvider(
          create: (_) => my_profile.MyProfileBloc(
              userRepository:
                  context.read<repositorys.RepositorysCubit>().userRepository,
              authBloc: context.read<auth.AuthBloc>())
            ..add(my_profile.FetchMyProfile())),
    ], child: _MyProfileScreen());
  }
}

class _MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepository =
        context.read<repositorys.RepositorysCubit>().userRepository;
    final meBloc = context.read<me.MeBloc>();
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text('My Profile'),
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<me.MeBloc, me.MeState>(listener: (context, state) {
                // if(state.me.error != )
              }),
              BlocListener<my_profile.MyProfileBloc, my_profile.MyProfileState>(
                  listener: (context, state) {}),
            ],
            child: Builder(builder: ((context) {
              final myProfileState =
                  context.watch<my_profile.MyProfileBloc>().state;
              final meState = context.watch<me.MeBloc>().state;
              return Column(children: [
                _ProfileForm(
                    profileName: 'avatar',
                    profileWidget: widgets.UserAvatar(
                      id: meState.me.id,
                      name: meState.me.name,
                      avatarUrl: meState.me.avatarUrl,
                    ),
                    onTap: () => _onTapAvatarProfileForm(
                        context, userRepository, meBloc)),
                _ProfileForm(
                    profileName: 'name',
                    profileWidget: Text(meState.me.name),
                    onTap: () {
                      // context.router.push(EditPersonProfileRoute(
                      //     inputLabel: Config.instance().pleaseInputNewName,
                      //     accountJsonKey: kName));
                    }),
                _ProfileForm(
                  profileName: 'id',
                  profileWidget: Text(meState.me.id),
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
            }))));
  }

  void _onTapAvatarProfileForm(BuildContext context,
      user_repository.UserRepository userRepository, me.MeBloc meBloc) async {
    try {
      final picker = image_picker.ImagePicker();
      final pickedImage = await picker.pickImage(
          source: image_picker.ImageSource.gallery,
          maxHeight: configs.Config.instance().profilePictureMaxHeight,
          maxWidth: configs.Config.instance().profilePictureMaxWidth,
          requestFullMetadata: false);
      if (pickedImage == null) {
        throw 'image not picked';
      }
      final avatar = await userRepository.preSignedAvatarUrl();
      if (avatar.error != user_repository.UserError.none) {
        throw 'presigned avatar url error(${avatar.error})';
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
      final response =
          await http.put(Uri.parse(avatar.preSignedUrl), body: imageBytes);
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(name: _kLogSource, 'response code(${response.statusCode}');
        meBloc.add(me.UpdateAvatarUrl(avatar.anonymousAccessUrl));
      } else {
        throw 'put avatar to s3 error, response code(${response.statusCode}';
      }
    } on String catch (err) {
      log(name: _kLogSource, err);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    } catch (e) {
      log(name: _kLogSource, e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
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
