import 'package:flutter/material.dart';

import '../mealpage/mealpage.dart';
import '../settings/settings.dart';
import '../stats/statspage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<BottomNav> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[
    const StatsPage(),
    const MealPage(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBarItem = const BottomNavigationBarItem(
      icon: Icon(Icons.stacked_bar_chart),
      label: "Stats",
    );
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 10.5,
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            bottomNavigationBarItem,
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
