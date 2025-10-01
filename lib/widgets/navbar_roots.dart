import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../pages/finances.dart';
import '../pages/profil_page.dart';
import '../sreems/desk_screem.dart';
import '../sreems/home_screem.dart';
import '../sreems/messages_screem.dart';
import '../sreems/news_screem.dart';
import '../sreems/service_screem.dart';
import '../sreems/setting_screem.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      ServiceScreem(),
      NewsScreem(),
      OrgChartPage(),
      MemberLoansScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Accueil",
        activeColorPrimary: const Color(0xFF7165D6),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.news),
        title: "Actualité",
        activeColorPrimary: const Color(0xFF7165D6),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.desk),
        title: "Bureau",
        activeColorPrimary: const Color(0xFF7165D6),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.trending_up),
        title: "Finance",
        activeColorPrimary: const Color(0xFF7165D6),
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: "Paramètres",
        activeColorPrimary: const Color(0xFF7165D6),
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style6,
      confineToSafeArea: true,
       navBarHeight: 40,  
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
    );
  }
}
