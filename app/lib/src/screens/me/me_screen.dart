import 'package:app/src/configs/configs.dart';
import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/route.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

import '../../features/me/me.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return BlocProvider(
        create: (_) => MeBloc(
            UserRepository(
                url: Config.instance().userServiceUrl,
                token: authBloc.state.auth.accessToken),
            authBloc),
        child: _MeScreen());
  }
}

class _MeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.grey[200],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _PersonProfileForm(),
                      _SettingsForm()
                    ]))));
  }
}

class _PersonProfileForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<MeBloc>().me();
    return InkWell(
        onTap: () {
          context.go('$routePathMe/$routePathMeMyProfile');
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 15, 20),
            color: Colors.white,
            child: Row(children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(Config.instance().logoPath),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Builder(builder: (context) {
                      final name =
                          context.select((MeBloc bloc) => bloc.state.me.name);
                      return Text(
                        name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      );
                    }),
                    const SizedBox(height: 10),
                    Builder(builder: (context) {
                      final id =
                          context.select((MeBloc bloc) => bloc.state.me.id);
                      return Text(
                        'id：$id',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      );
                    })
                  ],
                ),
              ),
              const Icon(Icons.chevron_right)
            ])));
  }
}

class _SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // context.router.push(const SettingsRoute());
        },
        child: const ItemCard(label: 'settings', iconData: Icons.settings));
  }
}
