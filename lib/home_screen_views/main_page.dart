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

  @override
  void initState()
  {
    super.initState();
    readData();
  }

  String writeName()
  {
    if(values["name"] != null)
    {
      return values["name"];
    }
    else
    {
      return "user";
    }
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
  double getWeeklyRemaining()
  {
    DateTime startDate;
    DateTime endDate;
    int loanDuration;
    double loanAmount;
    double spendPerWeek;
    if(values["iDat"] != null && values["oDat"] != null)
    {
      startDate = DateTime.parse(values["iDat"]);
      endDate = DateTime.parse(values["oDat"]);
      loanDuration = endDate.difference(startDate).inDays;
          
      if(values["loan"] != null)
      {
        loanAmount = double.parse(values["loan"].toString());
        int loanDurationInWeeks = (loanDuration / 7).ceil();
        spendPerWeek = double.parse((loanAmount / loanDurationInWeeks).toStringAsFixed(2));
        return spendPerWeek;
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
      "spend" : 0,
      "time" : getDateCode(DateTime.now()),
    });
    setState(() {
      readData();
    });
  }
  void updateData(double newLoanAmount)
  {
    dbRef.child(userID).update({
      "loan" : newLoanAmount,
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
      if (values != null)
      {
        print(values["loan"]);
      }
      else
      {
        print("loan amount not set");
      }
      setState(() {});
    });
  }
  void deleteData()
  {
    if (dbRef.child(userID) != null)
    {
      dbRef.child(userID).remove();
      values.clear();
      setState(() {
        readData();
      });
    }
  }
  Widget showLoanAmount()
  {
    if (values != null) 
    {
      if (values.length != 0)
      {
        return Text(
          ("£" + getWeeklyRemaining().toString()),
          style: GoogleFonts.karla(
            color: accentColour,
          ),
        );
      }    
    }
    return Text(
      ("Loan amount not set"),
      style: GoogleFonts.karla(
        color: Colors.red[700],
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
              Text(
                (writeGreeting() + ", " + writeName()),
                style: GoogleFonts.karla(
                  color: accentColour,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'EMAIL',
                style: GoogleFonts.karla(
                  color: accentColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: GoogleFonts.karla(
                  color: accentColour,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'REMAINING WEEKLY SPEND:',
                style: GoogleFonts.karla(
                  color: accentColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
              showLoanAmount(),
              SizedBox(height: 40),
              RaisedButton(
              onPressed: () {
                if (values != null)
                {
                  values.clear();
                }
                signOutGoogle();
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
            RaisedButton(
              child: Text("Update Data"),
              onPressed: ()
              {
                updateData(750);
              },
            ),
            RaisedButton(
              child: Text("Delete Data"),
              onPressed: ()
              {
                deleteData();
              },
            )
          ],
        ),
      );
 }
}
