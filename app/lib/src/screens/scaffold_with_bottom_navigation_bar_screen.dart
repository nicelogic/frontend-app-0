import 'package:app/src/constant/constant.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavigationBarScreen extends StatelessWidget {
  const ScaffoldWithBottomNavigationBarScreen({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: child,
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            TabItem(
                title: AppLocalizations.of(context)!
                    .bottomNavigationBarTabItemTitleChat,
                activeIcon: const Icon(
                  Icons.chat_bubble_outline,
                ),
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white60,
                )),
            TabItem(
                title: AppLocalizations.of(context)!
                    .bottomNavigationBarTabItemTitleContacts,
                activeIcon: const Icon(
                  Icons.contact_page_outlined,
                ),
                icon: const Icon(
                  Icons.contact_page_outlined,
                  color: Colors.white60,
                )),
            TabItem(
                title: AppLocalizations.of(context)!
                    .bottomNavigationBarTabItemTitleMe,
                activeIcon: const Icon(
                  Icons.person_outline,
                ),
                icon: const Icon(
                  Icons.person_outline,
                  color: Colors.white60,
                ))
          ],
          initialActiveIndex: _calculateSelectedIndex(context),
          onTap: (int index) => _onItemTapped(index, context),
        ));
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    if (location.startsWith(routePathChat)) {
      return 0;
    }
    if (location.startsWith(routePathContacts)) {
      return 1;
    }
    if (location.startsWith(routePathMe)) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(routePathChat);
        break;
      case 1:
        GoRouter.of(context).go(routePathContacts);
        break;
      case 2:
        GoRouter.of(context).go(routePathMe);
        break;
    }
  }
}
