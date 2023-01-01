import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/features/me/me.dart';
import 'package:app/src/features/repositorys/cubit/repositorys_cubit.dart';
import 'package:app/src/route.dart';
import 'package:app/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => MeBloc(
            userRepository: context.read<RepositorysCubit>().userRepository,
            authBloc: context.read<AuthBloc>()),
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
    context.read<MeBloc>().add(FetchMe());
    return InkWell(
        onTap: () {
          context.go('$routePathMe/$routePathMyProfile');
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 15, 20),
            color: Colors.white,
            child: Builder(builder: (context) {
              final meState = context.watch<MeBloc>().state;
              return Row(children: [
                UserAvatar(
                    id: meState.me.id,
                    name: meState.me.name,
                    avatarUrl: meState.me.avatarUrl,
                    radius: 32),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        meState.me.name.isEmpty
                            ? 'please set name'
                            : meState.me.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'id：${meState.me.id}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right)
              ]);
            })));
  }
}

class _SettingsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.go('$routePathMe/$routePathSettings');
        },
        child: const ItemCard(label: 'settings', iconData: Icons.settings));
  }
}
