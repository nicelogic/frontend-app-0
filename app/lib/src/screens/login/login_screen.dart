import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo/logo.png',
                  height: 120,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: Theme.of(context).textTheme.headline6!.apply(
                      color: Theme.of(context).primaryColor,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 26.0),
                const _WechatLoginButton(),
                const SizedBox(height: 10.0),
                const _UserNameLoginButton(),
              ],
            ),
          ),
        ));
  }
}

class _WechatLoginButton extends StatelessWidget {
  const _WechatLoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'wechat login',
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(FontAwesomeIcons.weixin, color: Colors.green),
      onPressed: () => debugPrint('begin login'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(170, 35),
      ),
    );
  }
}

class _UserNameLoginButton extends StatelessWidget {
  const _UserNameLoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () => {},
        icon: const Icon(FontAwesomeIcons.circleUser, color: Colors.yellow),
        label: const Text(
          'username login',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(170, 35),
        ));
  }
}
