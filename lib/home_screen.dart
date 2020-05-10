import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'home_screen_views/main_page.dart';
import 'home_screen_views/settings_page.dart';
import 'home_screen_views/trends_page.dart';

Color accentColour = Color.fromRGBO(2, 195, 154, 1);
Color backgroundColour = Color.fromRGBO(19, 21, 21, 1);

class FirstScreen extends StatefulWidget 
{
  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>
{
  int _selectedIndex = 1;
  final List<Widget> _children = 
  [
    TrendsScreen(),
    MainScreen(),
    SettingsScreen(),
  ];
  
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: backgroundColour,
      body: _children[_selectedIndex],
      bottomNavigationBar: GNav(
        gap: 5,
        activeColor: backgroundColour,
        color: accentColour,
        iconSize: 20,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        duration: Duration(milliseconds: 300),
        tabBackgroundColor: accentColour,
        tabs: 
        [
          GButton(
            icon: Icons.insert_chart,
            text: "Trends",
          ),
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.settings,
            text: "Settings",
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) 
        {
          setState(() {
            _selectedIndex = index;
          });
        }
      ),
    );
  }

}
