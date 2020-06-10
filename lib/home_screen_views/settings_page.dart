import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../home_screen.dart';
import '../sign_in.dart';

class SettingsScreen extends StatefulWidget 
{
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

TextEditingController nameController = new TextEditingController();
TextEditingController loanController = new TextEditingController();
bool accountActive = false;

DateTime startDate = DateTime.now();
DateTime endDate = DateTime.now().add(new Duration(days: 1));

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
        accountActive = true;
        nameController.text = values["name"];
        loanController.text = values["loan"].toString();
      }
      else
      {
        accountActive = false;
        nameController.clear();
        loanController.clear();
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
      });
    }
  }

  String getDateString(DateTime date)
  {
    String year = date.year.toString();
    String month = "";
    String day = "";
    if (date.month.toString().length < 2)
    {
      month = "0" + date.month.toString();
    }
    else
    {
      month = date.month.toString();
    }
    if (date.day.toString().length < 2)
    {
      day = "0" + date.day.toString();
    }
    else
    {
      day = date.day.toString();
    }
    return year + month + day;
  }

  void updateStartDate(DateTime newDate, String dateKey, bool startDate)
  {
    String newDateString = getDateString(newDate);
    String snackBarString = "";
    if (startDate)
    {
      snackBarString = "Start ";
    }
    else
    {
      snackBarString = "End ";
    }
    snackBarString += "date updated successfully";

    dbRef.child(userID).update({
      dateKey : newDateString,
    });
    setState(() 
    {
      readData();
      showSnackBar(snackBarString);
    });
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
            textInputAction: TextInputAction.none,
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
            textInputAction: TextInputAction.none,
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
      ],
    );
  }

  RaisedButton _pickStartDateButton()
  {
    return RaisedButton(
      onPressed: () {
        showDatePicker(
          context: context, 
          initialDate: startDate,
          firstDate: DateTime.now().subtract(new Duration(days: 1000)), 
          lastDate: startDate.add(new Duration(days: 1000)),
        ).then((date) {
          setState(() {
            if(date != null)
            {
              startDate = date;
              updateStartDate(date, "iDat", true);
              if(endDate.isBefore(startDate))
              {
                endDate = startDate.add(new Duration(days: 1));
              } 
            }
          });
        });
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Set Start Date",
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

  RaisedButton _pickEndDateButton()
  {
    return RaisedButton(
      onPressed: () {
        showDatePicker(
          context: context, 
          initialDate: endDate,
          firstDate: startDate.add(new Duration(days: 1)), 
          lastDate: startDate.add(new Duration(days: 1000)),
        ).then((date) {
          setState(() {
            if(date != null)
            {
              endDate = date;
              updateStartDate(date, "oDat", false);
            }
          });
        });
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Set End Date",
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

  Row _changeDateSetting()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _pickStartDateButton(),
        SizedBox(width: 20,),
        _pickEndDateButton(),
      ]
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

  Widget _showStartDate()
  {
    if (values != null && values.containsKey("iDat")) 
    {
      startDate = DateTime.parse(values["iDat"]);
      return Text(
        ("Start Date: " + DateFormat("yMMMMd").format(startDate)),
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      );    
    }
    else
    {
      return Text(
        ("Start Date: Not set"),
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      );  
    }
  }

  RaisedButton _submitButton()
  {
    return RaisedButton(
      onPressed: () {
        if (nameController.text != values["name"])
        {
          updateName();
        }
        if (loanController.text != values["loan"].toString())
        {
          updateLoan();
        }
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Update Details',
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

  Widget _showEndDate()
  {
    if (values != null && values.containsKey("oDat")) 
    {
      endDate = DateTime.parse(values["oDat"]);
      return Text(
        ("End Date: " + DateFormat("yMMMMd").format(endDate)),
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      );  
    }
    else
    {
      return Text(
        ("End Date: Not set"),
        style: GoogleFonts.karla(
          color: accentColour,
        ),
      ); 
    }
    
  }

  void deleteData()
  {
    if (dbRef.child(userID) != null)
    {
      dbRef.child(userID).remove();
      values.clear();
      setState(() {
        accountActive = false;
        readData();
      });
    }
  }

  RaisedButton _deleteDataButton()
  {
    return RaisedButton(
      onPressed: ()
      {
        //Show warning
        deleteData();
      },
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Delete Data',
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

  Center _mainColumn()
  {
    if(accountActive)
    {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _title(),
            SizedBox(height: 150),
            _changeNameSetting(),
            _changeLoanSetting(),
            SizedBox(height: 20),
            _showStartDate(),
            _showEndDate(),
            _changeDateSetting(),
            _deleteDataButton(),
            SizedBox(height: 30),
            _submitButton(),
          ],
        ),
      );
    }
    else
    {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _title(),
            SizedBox(height: 150),
            _submitButton(),
          ],
        ),
      );
    }
  }
}