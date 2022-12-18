import 'package:app/src/configs/configs.dart';
import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/me/me.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return BlocProvider(
        create: (_) => MeBloc(
            UserRepository(
                url: Config.instance().userServiceUrl,
                token: authBloc.state.auth.accessToken),
            authBloc),
        child: _MyProfileScreen());
  }
}

class _MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: const Text('My Profile'),
        ),
        body: Builder(builder: ((context) {
          final meState = context.watch<MeBloc>().state;
          return Column(children: [
            _ProfileForm(
              profileName: 'avatar',
              profileWidget:
                  UserAvatar(id: meState.me.id, name: meState.me.name),
              onTap: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxHeight: 36,
                    maxWidth: 36,
                    requestFullMetadata: false);
                if (pickedImage == null) {
                  return;
                }
                //   final imageBytes = await pickedImage.readAsBytes();
                //   final decodeImage = p_image.decodeImage(imageBytes);
                //   final imageData = p_image.encodePng(decodeImage!);
                //   final imageDataStream = ByteStream.fromBytes(imageData);
                //   await context.read<ObjectStorageRepository>().uploadImage(
                //         userId: account.id,
                //         objectName: Config.instance().objectStorageUserAvatar,
                //         data: imageDataStream,
                //       );
                //   ScaffoldMessenger.of(context)
                //       .showSnackBar(const SnackBar(content: Text('头像修改成功')));
                //
              },
            ),
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
              profileWidget: Text(meState.me.signature),
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
