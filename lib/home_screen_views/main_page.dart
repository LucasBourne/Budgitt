import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../home_screen.dart';
import '../sign_in.dart';
import '../login_page.dart';

class MainScreen extends StatefulWidget 
{
  @override
  MainScreenState createState() => MainScreenState();
}
class MainScreenState extends State<MainScreen>
{
  static Map<dynamic, dynamic> values = new Map<dynamic, dynamic>();
  final dbRef = FirebaseDatabase.instance.reference();
  bool loanActive = false;

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

  @override
  void initState()
  {
    super.initState();
    readData();
  }

  String writeName()
  {
    String nameToReturn = "";
    if(name != null)
    {
      nameToReturn = name;
    }
    if(values != null)
    {
      if(values["name"] != null)
      {
        nameToReturn = values["name"];
      }
    }
    return nameToReturn;
  }

  String writeGreeting()
  {
    String greeting = "";
    int hour = DateTime.now().hour;
    if (0 <= hour && hour < 12)
    {
      greeting = "Good morning";
    }
    else if (12 <= hour && hour < 17)
    {
      greeting = "Good afternoon";
    }
    else
    {
      greeting = "Good evening";
    }
    return greeting;
  }
  String getDateCode(DateTime date)
  {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor();
    String dateCode = date.year.toString() + "-" + weekNumber.toString();
    return dateCode; 
  }
  //Works out remaining spend per week based on how far through the tennancy the user is
  String getRemainingPerWeek()
  {
    DateTime loanStart;
    DateTime loanEnd;
    DateTime durationStart;
    int loanDuration;
    double loanAmount;
    String spendPerWeek;
    if(values["iDat"] != null && values["oDat"] != null)
    {
      loanStart = DateTime.parse(values["iDat"]);
      loanEnd = DateTime.parse(values["oDat"]);
      if(DateTime.now().isBefore(loanStart))
      {
        loanActive = false;
        return "Your loan has not yet been paid.";
      }
      else if(DateTime.now().isAfter(loanEnd))
      {
        loanActive = false;
        return "You've reached your end date. Well done!";
      }
      else
      {
        loanActive = true;
        durationStart = DateTime.now();
        loanDuration = loanEnd.difference(durationStart).inDays;
          
        if(values["loan"] != null)
        {
          loanAmount = double.parse(values["loan"].toString());
          int loanDurationInWeeks = (loanDuration / 7).ceil();
          spendPerWeek = (loanAmount / loanDurationInWeeks).toStringAsFixed(2);
          return "£" + spendPerWeek;
        }
      }
    }
    return null;
  }

  void writeData(double newLoanAmount)
  {
    dbRef.child(userID).set({
      "name" : name,
      "iDat" : "20200131",
      "oDat" : "20210131",
      "loan" : newLoanAmount,
      "wSpend" : 0,
      "tSpend" : 0,
      "dCode" : getDateCode(DateTime.now()),
    });
    setState(() {
      readData();
    });
  }
  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      setState(() {});
    });
  }
  Widget showLoanAmount()
  {
    if (values != null) 
    {
      if (values.containsKey("loan"))
      {
        return Text(
          getRemainingPerWeek(),
          style: GoogleFonts.karla(
            color: accentColour,
          ),
        );
      }    
    }
    return Text(
      ("Set up account in Settings"),
      style: GoogleFonts.karla(
        color: accentColour,
      ),
    );
  }

  Text _title()
  {
    return Text(
      "Home",
      style: GoogleFonts.karla(
        fontSize: 50,
        color: accentColour,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget build(BuildContext context) 
  {
   return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _title(),
              Text(
                (writeGreeting() + ", " + writeName()),
                style: GoogleFonts.karla(
                  color: accentColour,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 100),
              Text(
                'REMAINING WEEKLY SPEND:',
                style: GoogleFonts.karla(
                  color: accentColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
              showLoanAmount(),
              SizedBox(height: 10),
              RaisedButton(
              onPressed: () {
                if (values != null)
                {
                  values.clear();
                }
                signOutUser();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
              },
              color: accentColour,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sign Out',
                  style: GoogleFonts.karla(
                  color: backgroundColour,
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
              ),
            ),
            RaisedButton(
              child: Text("Write Data"),
              onPressed: ()
              {
                writeData(500);
              },
            ),
            RaisedButton(
              child: Text("Read Data"),
              onPressed: ()
              {
                readData();
              },
            ),
          ],
        ),
      );
 }
}
