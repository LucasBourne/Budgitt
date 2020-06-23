import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen_views/main_page.dart';
import 'home_screen_views/settings_page.dart';
import 'home_screen_views/trends_page.dart';
import 'login_page.dart';
import 'sign_in.dart';

Color accentColour = Colors.purple[300];
Color backgroundColour = Colors.grey[900];
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

  void _confirmSignOut() 
  {
    showDialog(
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog(
          backgroundColor: backgroundColour,
          title: Text(
            "Sign Out",
            style: GoogleFonts.karla(
              color: accentColour,
            ),
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style: GoogleFonts.karla(
              color: accentColour,
            ),
          ),
          actions: <Widget>[
            //buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Yes",
                style: GoogleFonts.karla(
                  color: accentColour,
                ),
              ),
              onPressed: () {
                signOutUser();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage(true);}), ModalRoute.withName('/'));
              },
            ),
            FlatButton(
              child: Text(
                "No",
                style: GoogleFonts.karla(
                  color: accentColour,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }


  RaisedButton _signOutButton()
  {
    return RaisedButton(
      onPressed: () {
        _confirmSignOut();
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
            textStyle: GoogleFonts.karla(
              fontWeight: FontWeight.bold,
              color: backgroundColour,
            ),
          ),
          GButton(
            icon: Icons.home,
            text: "Home",
            textStyle: GoogleFonts.karla(
              fontWeight: FontWeight.bold,
              color: backgroundColour,
            ),
          ),
          GButton(
            icon: Icons.settings,
            text: "Settings",
            textStyle: GoogleFonts.karla(
              fontWeight: FontWeight.bold,
              color: backgroundColour,
            ),
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
