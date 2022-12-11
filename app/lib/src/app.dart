import 'package:app/src/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        authReposiotryUrl: "https://auth.app0.env0.luojm.com:9443/query");
    return MultiBlocProvider(
        providers: [BlocProvider(create: (_) => authBloc)],
        child: AnimatedBuilder(
          animation: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(
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
              routerConfig: router(authBloc: authBloc),
            );
          },
        ));
  }
}
