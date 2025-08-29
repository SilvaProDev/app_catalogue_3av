import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/finances.dart';
import '../sreems/dashbord_screem.dart';
import '../sreems/desk_screem.dart';
import '../sreems/home_screem.dart';
import '../sreems/messages_screem.dart';
import '../sreems/news_screem.dart';
import '../pages/profil_page.dart';
import '../sreems/service_screem.dart';
import '../sreems/setting_screem.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _indexSelected = 0;

  final _screems = [
    // HomeScreem(),
     ServiceScreem(),
    NewsScreem(),
    OrgChartPage(),
    MemberLoansScreen(),
    // DashboardScreen(),
     SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screems[_indexSelected],
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7165D6),
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,  // Réduit pour un meilleur affichage
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          currentIndex: _indexSelected,
          onTap: (value) {
            setState(() {
              _indexSelected = value;
            });
          },
          items: const [
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.home_filled),
            //   label: "Accueil",
            // ),
             BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: "Accueil",
            ),
             BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news),
              label: "Actualité",
            ),
           
           
            BottomNavigationBarItem(
              icon: Icon(Icons.desk),
              label: "Bureau",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: "Finance",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.assignment),
            //   label: "Dashbord",
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Paramètres",
            ),
          ],
        ),
      ),
    );
  }
}