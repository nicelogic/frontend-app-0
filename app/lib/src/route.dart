import 'package:app/src/features/add_contacts_applys/cubit/add_contacts_applys_cubit.dart';
import 'package:app/src/features/auth/auth.dart' as auth;
import 'package:app/src/features/my_profile/my_profile.dart';
import 'package:app/src/features/query_contacts/models/queried_contacts.dart';
import 'package:app/src/screens/contacts/add_contacts_screen.dart';
import 'package:app/src/screens/contacts/contacts_profile_screen.dart';
import 'package:app/src/screens/contacts/contacts_screen.dart';
import 'package:app/src/screens/contacts/new_contacts_screen.dart';
import 'package:app/src/screens/me/edit_name_screen.dart';
import 'package:app/src/screens/me/edit_signature_screen.dart';
import 'package:app/src/screens/me/settings_screen.dart';
import 'package:app/src/screens/me/me_screen.dart';
import 'package:app/src/screens/me/my_profile_screen.dart';
import 'package:app/src/screens/login/login_screen.dart';
import 'package:app/src/screens/login/username_login_screen.dart';
import 'package:app/src/screens/chat/chat_screen.dart';
import 'package:app/src/screens/scaffold_with_bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tuple/tuple.dart';

import 'features/auth/auth.dart';
import 'features/me/me.dart';

const routePathMe = '/me';
const routePathMyProfile = 'my_profile';
const routePathEditName = 'edit_name';
const routePathEditSignature = 'edit_signature';
const routePathSettings = 'settings';
const routePathContacts = '/contacts';
const routePathAddContacts = 'add_contacts';
const routePathContactsProfile = 'contacts_profile';
const routePathContactsProfileQueryParamId = 'id';
const routePathContactsProfileQueryParamName = 'name';
const routePathContactsProfileQueryParamAavatrUrl = 'avatar_url';
const routePathNewContacts = 'new_contacts';
const routePathChat = '/chat';
const routePathLogin = '/login';
const routePathLoginUserNameLogin = 'username_login';

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
                  routes: <RouteBase>[
                    GoRoute(
                        path: routePathAddContacts,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: ((context, state) {
                          return const AddContactsScreen();
                        }),
                        routes: <RouteBase>[
                          GoRoute(
                              name: routePathContactsProfile,
                              path: routePathContactsProfile,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: ((context, state) {
                                final id = state.queryParams[
                                        routePathContactsProfileQueryParamId]
                                    as String;
                                final name = state.queryParams[
                                        routePathContactsProfileQueryParamName]
                                    as String;
                                final avatarUrl = state.queryParams[
                                        routePathContactsProfileQueryParamAavatrUrl]
                                    as String;
                                return ContactsProfileScreen(
                                  contacts:
                                      QueriedContacts(id, name, avatarUrl),
                                );
                              })),
                        ]),
                    GoRoute(
                      path: routePathNewContacts,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: ((context, state) {
                        final addContactsApplysCubit =
                            state.extra as AddContactsApplysCubit;
                        return NewContactsScreen(
                            addContactsApplysCubit: addContactsApplysCubit);
                      }),
                    )
                  ]),
              GoRoute(
                  path: routePathMe,
                  builder: (BuildContext context, GoRouterState state) {
                    return const MeScreen();
                  },
                  routes: <RouteBase>[
                    GoRoute(
                        path: routePathMyProfile,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: ((context, state) {
                          if (state.extra is Tuple2<MeBloc, MyProfileBloc>) {
                            final tupleBlocs =
                                state.extra as Tuple2<MeBloc, MyProfileBloc>;
                            return MyProfileScreen(
                              meBloc: tupleBlocs.item1,
                            );
                          } else {
                            return MyProfileScreen(
                              meBloc: state.extra as MeBloc,
                            );
                          }
                        }),
                        routes: <RouteBase>[
                          GoRoute(
                              path: routePathEditName,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: ((context, state) {
                                return EditNameScreen(
                                  meBloc: state.extra as MeBloc,
                                );
                              })),
                          GoRoute(
                              path: routePathEditSignature,
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: ((context, state) {
                                final tupleBlocs = state.extra
                                    as Tuple2<MeBloc, MyProfileBloc>;
                                return EditSignatureScreen(
                                  myProfileBloc: tupleBlocs.item2,
                                  meBloc: tupleBlocs.item1,
                                );
                              }))
                        ]),
                    GoRoute(
                        path: routePathSettings,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: ((context, state) {
                          return const SettingsScreen();
                        })),
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
