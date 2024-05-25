import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:your_eyes/constants/colors.dart';
import 'package:your_eyes/setting_page.dart';
import 'home_page.dart';



class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(

        icons: [
          Icons.home_outlined,
          Icons.settings_outlined,
        ],
        activeIndex: _currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        activeColor: backgroundColor,
        splashColor: backgroundColor,
        inactiveColor: Colors.grey.withOpacity(0.5),
        iconSize: 34,

        notchMargin: 10, // تحديد المسافة بين الأيقونات والكلمات
        elevation: 15,

        leftCornerRadius: 32,
        rightCornerRadius: 32,

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,



      ),


    );
  }
}

