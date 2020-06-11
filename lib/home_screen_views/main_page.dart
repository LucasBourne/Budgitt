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

TextEditingController transactionController = new TextEditingController();

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
    String weekNumber = ((dayOfYear - date.weekday + 10) / 7).floor().toString();
    if (weekNumber.length < 2)
    {
      weekNumber = "0" + weekNumber;
    }
    String dateCode = date.year.toString() + weekNumber;
    return dateCode; 
  }
  Text getWeeklyAfterSpend()
  {
    String temp = getRemainingPerWeek();
    if (!loanActive)
    {
      return Text(
        temp,
        style: GoogleFonts.karla(
          color: Colors.amber[600]
        ),
      );
    }
    else
    {
      double beforeWeeklyDeduction = double.parse(temp);
      double toDeduct = values["wSpend"].toDouble();
      double afterWeeklyDeduction = beforeWeeklyDeduction - toDeduct;
      TextStyle style;
      if (toDeduct + values["tSpend"] > values["loan"])
      {
        style = GoogleFonts.karla(
          color: Colors.red[400],
        );
      }
      else if (toDeduct > beforeWeeklyDeduction)
      {
        style = GoogleFonts.karla(
          color: Colors.amber[600],
        );
      }
      else
      {
        style = GoogleFonts.karla(
          color: accentColour,
        );
      }
      return Text(
        "£" + afterWeeklyDeduction.toStringAsFixed(2),
        style: style,
      );
    }
  }
  //Works out remaining spend per week based on how far through the tennancy the user is
  String getRemainingPerWeek()
  {
    DateTime loanStart;
    DateTime loanEnd;
    DateTime durationStart;
    int loanDuration;
    double remainingLoan;
    double remainingPerWeek;
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
        loanDuration = loanEnd.difference(durationStart).inDays + 1;

        if(int.parse(getDateCode(DateTime.now())) > int.parse(values["dCode"]))
        {
          double oldTotal = values["tSpend"].toDouble();
          dbRef.child(userID).update({
            "tSpend" : oldTotal + values["wSpend"],
            "wSpend" : 0.0,
            "dCode" : getDateCode(DateTime.now())
          });
          setState(() {
            readData();
          });
        }
        else
        {
          if(values["loan"] != null && values["tSpend"] != null)
          {
            remainingLoan = double.parse(values["loan"].toString()) - double.parse(values["tSpend"].toString());
            int loanDurationInWeeks = (loanDuration / 7).ceil();
            remainingPerWeek = double.parse((remainingLoan / loanDurationInWeeks).toString());
            return remainingPerWeek.toString();
          }        
        }
      }
    }
    return "0";
  }

  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      setState(() {});
    });
  }

  Padding _transactionField()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextField(
        style: GoogleFonts.karla(color: accentColour),
        controller: transactionController,
        cursorColor: accentColour,
        onEditingComplete: ()
        {
          handlePayment();
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: accentColour
            ),
          ),
          labelText: "Transaction Amount (£)",
        ),
        obscureText: false,
        autocorrect: false,
        keyboardType: TextInputType.number,
      ),
    );
  }

  void handlePayment()
  {
    if (transactionController.text.trim().isEmpty)
    {
      showSnackBar("ERROR: Transaction amount cannot be blank");
    }
    else
    {
      double transactionValue = double.parse(transactionController.text);
      String newWeeklySpend = (values["wSpend"] + transactionValue).toStringAsFixed(2);

      dbRef.child(userID).update({
        "wSpend" : double.parse(newWeeklySpend),
      });
      setState(() 
      {
        readData();
        showSnackBar("Payment of £" + transactionValue.toStringAsFixed(2) + " made successfully");
        transactionController.clear();
      });
    }
  }

  Row _transactionRow()
  {
    if(loanActive)
    {
      return Row(
        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: _transactionField(),
          ),
          _submitPaymentButton(),
          SizedBox(width: 10),
        ],
      );
    }
    else
    {
      return Row();
    }
  }

  RaisedButton _submitPaymentButton()
  {
    return RaisedButton(
      onPressed: ()
      {
        handlePayment();
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Add',
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
    );
  }

  Widget showLoanAmount()
  {
    if (values != null && values.length == 7) 
    {
      return getWeeklyAfterSpend();   
    }
    else
    {
      loanActive = false;
      return Text(
        ("Set up account in Settings"),
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      );
    }
    
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
              _transactionRow(),
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
          ],
        ),
      );
 }
}