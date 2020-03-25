import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'sign_in.dart';

Color accentColour = Color.fromRGBO(2, 195, 154, 1);
Color backgroundColour = Color.fromRGBO(19, 21, 21, 1);

class FirstScreen extends StatefulWidget 
{
  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>
{
  final dbRef = FirebaseDatabase.instance.reference();
  static Map<dynamic, dynamic> values = new Map<dynamic, dynamic>();
  
  @override
  void initState()
  {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: backgroundColour,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                ("Good morning, " + name),
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
                values.clear();
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
      ),
    );
  }
  void writeData(int loanAmount)
  {
    //User user = new User(int.parse(loanAmount), userID);
    dbRef.child(userID).set(
      {
        "name" : name,
        "loanAmount" : loanAmount,
      }
    );
    setState(() {
      readData();
    });
  }

  void updateData(int newLoanAmount)
  {
    dbRef.child(userID).update(
      {
        "loanAmount" : newLoanAmount,
      }
    );
    setState(() {
      readData();
    });
  }
  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      print(values["loanAmount"]);
      setState(() {});
    });
  }
                /*
    dbRef.once().then((DataSnapshot dataSnapshot)
    {
      print(dataSnapshot.value(0));
    });
    */
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
}