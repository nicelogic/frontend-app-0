import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:app/src/screens/contacts_screen/contacts_screen.dart';
import 'package:app/src/screens/login_screen/login_screen.dart';
import 'package:app/src/screens/username_login_screen/username_login_screen.dart';
import 'package:app/src/screens/me_screen/me_screen.dart';
import 'package:app/src/screens/my_profile_screen/my_profile_screen.dart';
import 'package:app/src/screens/chat_screen/chat_screen.dart';
import 'package:app/src/screens/scaffold_with_bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/auth.dart';

const routePathMe = '/me';
const routePathMeMyProfile = 'myprofile';
const routePathContacts = '/contacts';
const routePathChat = '/chat';
const routePathLogin = '/login';
const routePathLoginUserNameLogin = 'usernamelogin';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

router() => GoRouter(
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      initialLocation: routePathChat,
      redirect: (BuildContext context, GoRouterState state) {
        if (state.location == '$routePathLogin/$routePathLoginUserNameLogin') {
          return null;
        }
        final authStatus = context.read<AuthBloc>().state.status;
        if (authStatus == auth.AuthenticationStatus.unauthenticated) {
          return routePathLogin;
        } else {
          return null;
        }
      },
      routes: <RouteBase>[
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (BuildContext context, GoRouterState state, Widget child) {
              return ScaffoldWithBottomNavigationBarScreen(child: child);
            },
            routes: <RouteBase>[
              GoRoute(
                path: routePathChat,
                builder: (BuildContext context, GoRouterState state) {
                  return const ChatScreen();
                },
              ),
              GoRoute(
                path: routePathContacts,
                builder: (BuildContext context, GoRouterState state) {
                  return const ContactsScreen();
                },
              ),
              GoRoute(
                  path: routePathMe,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MeScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: routePathMeMyProfile,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: ((context, state) {
                          return const MyProfileScreen();
                        }))
                  ])
            ]),
        GoRoute(
            path: routePathLogin,
            builder: ((context, state) {
              return const LoginScreen();
            }),
            routes: [
              GoRoute(
                path: routePathLoginUserNameLogin,
                builder: (context, state) {
                  return UserNameLoginScreen();
                },
              )
            ])
      ],
    );
