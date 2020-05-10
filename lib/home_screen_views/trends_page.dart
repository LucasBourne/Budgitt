import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home_screen.dart';

class TrendsScreen extends StatefulWidget 
{
  @override
  TrendsScreenState createState() => TrendsScreenState();
}

class TrendsScreenState extends State<TrendsScreen>
{
  @override
  Widget build(BuildContext context) 
  {
    return Center(
      child: Text(
        "Trends Screen", 
        style: GoogleFonts.karla(
          color: accentColour,
          fontStyle: FontStyle.italic,
        ),         
      ),
    );
  }
}