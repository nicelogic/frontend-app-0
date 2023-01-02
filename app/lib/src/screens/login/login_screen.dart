import 'package:app/src/configs/configs.dart';
import 'package:app/src/route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(AppLocalizations.of(context)!.loginScreenAppBarTitleLogin),
            centerTitle: true),
        body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  Config.instance().logoPath,
                  height: 120,
                ),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .apply(color: Theme.of(context).primaryColor),
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

final _loginButtonStyle = ElevatedButton.styleFrom(
  alignment: Alignment.centerLeft,
  minimumSize: const Size(180, 35),
);

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
      style: _loginButtonStyle,
    );
  }
}

class _UserNameLoginButton extends StatelessWidget {
  const _UserNameLoginButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () =>
            context.go('$routePathLogin/$routePathLoginUserNameLogin'),
        icon: const Icon(FontAwesomeIcons.circleUser, color: Colors.yellow),
        label: const Text(
          'username login',
          style: TextStyle(color: Colors.white),
        ),
        style: _loginButtonStyle);
  }
}
