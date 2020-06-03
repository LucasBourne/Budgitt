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
TextEditingController loanController = new TextEditingController();

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
    return _mainColumn();
  }

  String getName()
  {
    if(values["name"] != null)
    {
      return values["name"];
    }
    else
    {
      return "Not set";
    }
  }

  void showSnackBar(String message)
  {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: accentColour,
      content: Text(
        message,
        style: GoogleFonts.karla(
          color: backgroundColour
        ),
      ),
    );
    setState(() 
    {
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void updateName()
  {
    if (nameController.text.trim().isEmpty)
    {
      showSnackBar("ERROR: Name cannot be blank");
    }
    else
    {
      dbRef.child(userID).update({
        "name" : nameController.text,
      });
      setState(() 
      {
        readData();
        showSnackBar("Name updated to " + nameController.text);
      nameController.clear();
      });
    }
  }

  void updateLoan()
  {
    if (loanController.text.trim().isEmpty)
    {
      showSnackBar("ERROR: Loan amount cannot be blank");
    }
    else if(double.tryParse(loanController.text.trim()) == null) 
    {
      showSnackBar("ERROR: Loan amount is invalid");
    }
    else if(double.parse(loanController.text.trim()) < 0)
    {
      showSnackBar("ERROR: Loan amount cannot be negative");
    }
    else
    {
      String newLoanAmount = double.parse(loanController.text).toStringAsFixed(2);
      dbRef.child(userID).update({
        "loan" : double.parse(newLoanAmount),
      });
      setState(() 
      {
        readData();
        showSnackBar("Loan value updated to £" + newLoanAmount);
        loanController.clear();
      });
    }
  }

  Row _changeNameSetting()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10),
        Flexible(
          child: TextField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: accentColour),
            cursorColor: accentColour,
            controller: nameController,
            onEditingComplete: ()
            {
              updateName();
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour
                ),
              ),
              labelText: "New name",
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          iconSize: 20,
          color: accentColour,
          onPressed: () 
          {
            updateName();
          },
        ),
      ],
    );
  }

  Row _changeLoanSetting()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10),
        Flexible(
          child: TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            style: TextStyle(color: accentColour),
            cursorColor: accentColour,
            controller: loanController,
            onEditingComplete: ()
            {
              updateLoan();
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour
                ),
              ),
              labelText: "New loan amount",
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          iconSize: 20,
          color: accentColour,
          onPressed: () 
          {
            updateLoan();
          },
        ),
      ],
    );
  }

  Text _title()
  {
    return Text(
      "Settings",
      style: GoogleFonts.karla(
        fontSize: 50,
        color: accentColour,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Center _mainColumn()
  {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _title(),
          SizedBox(height: 100),
          _changeNameSetting(),
          _changeLoanSetting(),
        ],
      ),
    );
  }
}