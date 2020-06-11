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
            onEditingComplete: ()
            {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour
                ),
              ),
              labelText: "Name",
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
            onEditingComplete: ()
            {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: accentColour
                ),
              ),
              labelText: "Loan amount (£)",
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
              if(endDate.isBefore(startDate) || startDate == endDate)
              {
                endDate = startDate.add(new Duration(days: 1));
              } 
              FocusScope.of(context).requestFocus(new FocusNode());
            }
          });
        });
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Set Date",
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
          firstDate: startDate, 
          lastDate: startDate.add(new Duration(days: 1000)),
        ).then((date) {
          setState(() {
            if(date != null)
            {
              endDate = date;
            }
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        });
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Set Date",
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
    }
    return Text(
      ("Start Date: " + DateFormat("yMMMMd").format(startDate)),
      style: GoogleFonts.karla(
        color: accentColour,
      ),
    );    
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

  RaisedButton _submitButton()
  {
    return RaisedButton(
      onPressed: () {
        if(values == null)
        {
          if(nameController.text.trim().isEmpty)
          {
            showSnackBar("ERROR: Name cannot be blank");
          }
          else if(loanController.text.trim().isEmpty)
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
            dbRef.child(userID).set({
            "dCode" : getDateCode(DateTime.now()),
            "iDat" : getDateString(startDate),
            "loan" : double.parse(loanController.text),
            "name" : nameController.text,
            "oDat" : getDateString(endDate),
            "tSpend" : 0,
            "wSpend" : 0,
            });
            accountActive = true;
            showSnackBar("Account successfully created");
          }
        }
        else
        {
          if (nameController.text != values["name"])
          {
            updateName();
            dbRef.child(userID).update({
              "dCode" : getDateCode(DateTime.now()),
            });
          }
          if (loanController.text != values["loan"].toString())
          {
            updateLoan();
            dbRef.child(userID).update({
              "dCode" : getDateCode(DateTime.now()),
            });
          }
          updateStartDate(startDate, "iDat", true);
          updateStartDate(endDate, "oDat", false);
        }
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      color: accentColour,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.save,
              color: backgroundColour,
            ),
            SizedBox(width: 10),
            Text(
             'Save Details',
              style: GoogleFonts.karla(
                color: backgroundColour,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40)
      ),
    );
  }

  Row _startDateFunctions()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _showStartDate(),
        _pickStartDateButton(),
      ],
    );
  }

  Row _endDateFunctions()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _showEndDate(),
        _pickEndDateButton(),
      ],
    );
  }

  Widget _showEndDate()
  {
    if (values != null && values.containsKey("oDat")) 
    {
      endDate = DateTime.parse(values["oDat"]);
    }
    return Text(
      ("End Date: " + DateFormat("yMMMMd").format(endDate)),
      style: GoogleFonts.karla(
        color: accentColour,
      ),
    );  
  }

  void deleteData()
  {
    if (dbRef.child(userID) != null)
    {
      dbRef.child(userID).remove();
      values.clear();
      nameController.clear();
      loanController.clear();
      startDate = DateTime.now();
      endDate = DateTime.now().add(new Duration(days: 1));
      accountActive = false;
      showSnackBar("User data successfully deleted");
      setState(() {
        readData();
      });
    }
  }

  void _confirmDelete() 
  {
    showDialog(
      context: context,
      builder: (BuildContext context) 
      {
        return AlertDialog(
          backgroundColor: backgroundColour,
          title: Text(
            "Delete Data",
            style: GoogleFonts.karla(
              color: accentColour,
            ),
          ),
          content: Text(
            "Warning: This will delete all current user information. This cannot be undone. Would you like to continue with deletion?",
            style: GoogleFonts.karla(
              color: accentColour,
            ),
          ),
          actions: <Widget>[
            //buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Yes",
                style: GoogleFonts.karla(
                  color: accentColour,
                ),
              ),
              onPressed: () {
                deleteData();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "No",
                style: GoogleFonts.karla(
                  color: accentColour,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  RaisedButton _deleteDataButton()
  {
    return RaisedButton(
      onPressed: ()
      {
        _confirmDelete();
      },
      color: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Delete Data',
          style: GoogleFonts.karla(
            color: Colors.red[400],
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
    if (accountActive)
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
            SizedBox(height: 10),
            _startDateFunctions(),
            _endDateFunctions(),
            SizedBox(height: 50),
            _submitButton(),
            _deleteDataButton(),
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
            _changeNameSetting(),
            _changeLoanSetting(),
            SizedBox(height: 10),
            _startDateFunctions(),
            _endDateFunctions(),
            SizedBox(height: 50),
            _submitButton(),
          ],
        ),
      );
    }
  }
}