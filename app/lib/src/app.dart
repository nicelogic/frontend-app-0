import 'package:app/src/configs/configs.dart';
import 'package:app/src/features/auth/bloc/auth_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:user_repository/user_repository.dart';
import 'features/me/me.dart';
import 'settings/settings_controller.dart';
import 'route.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(
        authRepository: AuthRepository(url: Config.instance().authServiceUrl));
    return AnimatedBuilder(
          animation: settingsController,
          builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
            providers: [BlocProvider(create: (_) => authBloc)],
            child: BlocProvider(
                create: (_) => MeBloc(
                    UserRepository(
                        url: Config.instance().userServiceUrl,
                        token: authBloc.state.auth.accessToken),
                    authBloc),
                child: MaterialApp.router(
              restorationScopeId: 'app',
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
              ],
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: ThemeData(),
              darkTheme: ThemeData.dark(),
              themeMode: settingsController.themeMode,
              routerConfig: router(),
                )));
          },
    );
  }
}
