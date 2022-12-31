import 'package:app/src/features/auth/auth.dart';
import 'package:app/src/route.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserNameLoginScreen extends StatelessWidget {
  UserNameLoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listViewChildren = [
      _UsernameInput(usernameController),
      const SizedBox(height: 12),
      _PasswordInput(passwordController),
      _LoginButton(
        onTap: () async {
          final userName = usernameController.text;
          final password = passwordController.text;
          context
              .read<AuthBloc>()
              .add(AuthSignInByUserName(userName, password));
        },
      ),
    ];

    return Scaffold(
        appBar: AppBar(title: const Text('username login'), centerTitle: true),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              context.go(routePathChat);
            } else if (state.auth.error != AuthError.none) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.auth.error.name)));
              if (state.auth.error == AuthError.userNotExist) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('will auto register this username')));
                context.read<AuthBloc>().add(AuthSignUpByUserName(
                    usernameController.text, passwordController.text));
              }
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 54),
              children: listViewChildren,
            ),
          ),
        ));
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput(this.usernameController);

  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: TextField(
          textInputAction: TextInputAction.next,
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'username',
          ),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput(this.passwordController);

  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'password',
          ),
          obscureText: true,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.login),
            label: const Text(
              'register/login',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
