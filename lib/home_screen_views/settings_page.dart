import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

import '../home_screen.dart';
import '../sign_in.dart';

class SettingsScreen extends StatefulWidget 
{
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

TextEditingController nameController = new TextEditingController();

class SettingsScreenState extends State<SettingsScreen>
{
  static Map<dynamic, dynamic> values = new Map<dynamic, dynamic>();
  final dbRef = FirebaseDatabase.instance.reference();
  
  @override
  void initState()
  {
    super.initState();
    readData();
  }

  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      if (values != null)
      {
        print("User found");
      }
      else
      {
        print("User not found");
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
            TextField(
            style: GoogleFonts.karla(color: accentColour),
            controller: nameController,
            cursorColor: accentColour,
            decoration: InputDecoration(
              labelText: "New name",
              labelStyle: GoogleFonts.karla(color: accentColour),
              icon: Icon(Icons.person, color: accentColour,),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour, 
                  width: 3.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour, 
                  width: 3.0,
                ),
              )
            ),
            obscureText: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
          ),
          RaisedButton(
            child: Text(
              "Apply",
              style: GoogleFonts.karla(),
            ),
            onPressed: ()
            {
              dbRef.child(userID).update({
              "name" : nameController.text,
              });
              setState(() {
              readData();
            });
              //update name on database
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: accentColour,
            textColor: backgroundColour,
          ),  
        ],
      ),
    );
  }

  Padding _changeNameSetting()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          
        ],
      ),
    );
  }
}