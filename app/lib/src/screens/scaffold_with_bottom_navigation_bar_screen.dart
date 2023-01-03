import 'dart:developer';

import 'package:app/src/route.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

const _kLogSource = 'ScaffoldWithBottomNavigationBarScreen';

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
    try {
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
    } catch (e) {
      log(name: _kLogSource, e.toString());
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(routePathChat);
        break;
      case 1:
        context.go(routePathContacts);
        break;
      case 2:
        context.go(routePathMe);
        break;
    }
  }
}
