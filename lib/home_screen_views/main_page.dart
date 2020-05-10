import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void writeData(int newLoanAmount)
  {
    dbRef.child(userID).set({
      "name" : name,
      "loanAmount" : newLoanAmount,
    });
    setState(() {
      readData();
    });
  }
  void updateData(int newLoanAmount)
  {
    dbRef.child(userID).update({
      "loanAmount" : newLoanAmount,
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
        print(values["loanAmount"]);
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
          ("£" + values["loanAmount"].toString()),
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
                (writeGreeting() + ", " + name),
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
                'LOAN AMOUNT',
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
