import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/src/widgets/widgets.dart' as widgets;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image_cropper/image_cropper.dart' as image_cropper;
import 'package:app/src/configs/configs.dart' as configs;
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:app/src/features/me/me.dart' as me;
import 'package:app/src/features/my_profile/my_profile.dart' as my_profile;
import 'package:app/src/features/repositorys/repositorys.dart' as repositorys;
import 'package:user_repository/user_repository.dart' as user_repository;
import 'package:http/http.dart' as http;

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
              BlocListener<me.MeBloc, me.MeState>(
                  listenWhen: (previous, current) =>
                      current.me.error != user_repository.UserError.none,
                  listener: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(state.me.error.name)));
                  }),
              BlocListener<my_profile.MyProfileBloc, my_profile.MyProfileState>(
                  listenWhen: (previous, current) =>
                      current.myProfile.error != user_repository.UserError.none,
                  listener: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(content: Text(state.myProfile.error.name)));
                  }),
              BlocListener<me.MeBloc, me.MeState>(
                  listenWhen: (previous, current) =>
                      previous.me.avatarUrl != current.me.avatarUrl,
                  listener: (context, state) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(
                          content: Text('update avatar success')));
                  }),
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
      final croppedImage =
          await _cropImage(context: context, pickedImage: pickedImage);
      if (croppedImage == null) {
        throw 'image not cropped';
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
      final imageBytes = await croppedImage.readAsBytes();
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

  Future<image_cropper.CroppedFile?> _cropImage(
      {required BuildContext context,
      required image_picker.XFile pickedImage}) async {
    final maxHeight = configs.Config.instance().profilePictureMaxHeight.toInt();
    final maxWidth = configs.Config.instance().profilePictureMaxWidth.toInt();
    final croppedFile = await image_cropper.ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      compressFormat: image_cropper.ImageCompressFormat.png,
      compressQuality: 100,
      aspectRatioPresets: [
        image_cropper.CropAspectRatioPreset.square,
      ],
      cropStyle: image_cropper.CropStyle.circle,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      uiSettings: [
        image_cropper.AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: image_cropper.CropAspectRatioPreset.square,
            lockAspectRatio: true),
        image_cropper.IOSUiSettings(
          title: 'Cropper',
        ),
        image_cropper.WebUiSettings(
          context: context,
          presentStyle: image_cropper.CropperPresentStyle.dialog,
          boundary: image_cropper.CroppieBoundary(
            width: maxWidth,
            height: maxHeight,
          ),
          viewPort: image_cropper.CroppieViewPort(
              width: maxWidth, height: maxHeight, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    return croppedFile;
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
