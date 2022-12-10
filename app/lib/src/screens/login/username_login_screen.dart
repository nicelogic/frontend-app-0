import 'package:flutter/material.dart';

class UserNameLoginScreen extends StatelessWidget {
  const UserNameLoginScreen(
      {super.key, this.usernameController, this.passwordController});

  final TextEditingController? usernameController;
  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    final listViewChildren = [
      _UsernameInput(usernameController),
      const SizedBox(height: 12),
      _PasswordInput(passwordController),
      _LoginButton(
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('username login'), centerTitle: true),
      body: Align(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 54),
          children: listViewChildren,
        ),
      ),
    );
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
            onPressed: () => {},
            icon: const Icon(Icons.login),
            label: const Text(
              'register/login',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
