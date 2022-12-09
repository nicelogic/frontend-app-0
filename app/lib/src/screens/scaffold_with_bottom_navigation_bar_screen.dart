import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScaffoldWithBottomNavigationBarScreen extends StatefulWidget {
  const ScaffoldWithBottomNavigationBarScreen({Key? key}) : super(key: key);

  @override
  ScaffoldWithButtomNavigationBarScreenState createState() =>
      ScaffoldWithButtomNavigationBarScreenState();
}

class ScaffoldWithButtomNavigationBarScreenState
    extends State<ScaffoldWithBottomNavigationBarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            title:
                AppLocalizations.of(context)!.bottomNavigationBarTabItemTitleMe,
            activeIcon: const Icon(
              Icons.person_outline,
            ),
            icon: const Icon(
              Icons.person_outline,
              color: Colors.white60,
            ))
      ],
      initialActiveIndex: 0,
      onTap: (pageIndex) {
        // tabsRouter.setActiveIndex(pageIndex);
      },
    ));
  }
}
