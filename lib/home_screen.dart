import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen_views/main_page.dart';
import 'home_screen_views/settings_page.dart';
import 'home_screen_views/trends_page.dart';
import 'login_page.dart';
import 'sign_in.dart';

Color accentColour = Color.fromRGBO(2, 195, 154, 1);
Color backgroundColour = Color.fromRGBO(19, 21, 21, 1);
var titles = ["Trends", "Home", "Settings"];
String titleText = titles[1];

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
    titleText = titles[1];
  }

  RaisedButton _signOutButton()
  {
    return RaisedButton(
      onPressed: () {
        signOutUser();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
      },
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Sign Out',
          style: GoogleFonts.karla(
            color: accentColour,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40)
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColour,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          titleText,
          style: GoogleFonts.karla(
            color: accentColour,
            fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            _signOutButton(),
          ],
      ),
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
            textStyle: GoogleFonts.karla(fontWeight: FontWeight.bold),
          ),
          GButton(
            icon: Icons.home,
            text: "Home",
            textStyle: GoogleFonts.karla(fontWeight: FontWeight.bold),
          ),
          GButton(
            icon: Icons.settings,
            text: "Settings",
            textStyle: GoogleFonts.karla(fontWeight: FontWeight.bold),
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) 
        {
          setState(() {
            titleText = titles[index];
            _selectedIndex = index;
          });
        }
      ),
    );
  }
}
