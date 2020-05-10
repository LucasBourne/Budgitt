import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'database_functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'first_screen.dart';

class SettingsScreen extends StatefulWidget 
{
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Center(
      child: Text(
        "Settings Screen", 
        style: GoogleFonts.karla(
          color: accentColour,
          fontStyle: FontStyle.italic,
        ),  
      ),    
    );
  }
}