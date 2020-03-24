import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'login_page.dart';
import 'sign_in.dart';
import 'User.dart';

class FirstScreen extends StatefulWidget 
{
  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>
{
  final dbRef = FirebaseDatabase.instance.reference();
  static Map<dynamic, dynamic> values = new Map<dynamic, dynamic>();
  List<User> _userList;
  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;
  Query _userQuery;
  
  @override
  void initState()
  {
    super.initState();

    _userList = new List();
    _userQuery = dbRef.child("Users").child(userID).orderByChild("userId").equalTo(userID);
    _onUserChangedSubscription = _userQuery.onChildChanged.listen(onEntryChanged);
    _onUserAddedSubscription = _userQuery.onChildAdded.listen(onEntryAdded);
  }

  @override
  void dispose()
  {
    _onUserChangedSubscription.cancel();
    _onUserAddedSubscription.cancel();
    super.dispose();
  }

  onEntryAdded(Event event)
  {
    setState(() {
      _userList.add(User.fromSnapshot(event.snapshot));
    });
  }
  
  onEntryChanged(Event event)
  {
    var oldEntry = _userList.singleWhere((entry)
    {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _userList[_userList.indexOf(oldEntry)] = User.fromSnapshot(event.snapshot);
    });
  }

  

  Widget build(BuildContext context) 
  {
    


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'LOAN AMOUNT',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              showLoanAmount(),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
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
                  writeData("666");
                  setState(() {
                    
                  });
                },
              ),
              RaisedButton(
                child: Text("Read Data"),
                onPressed: ()
                {
                  readData();
                  setState(() {
                    
                  });
                },
              ),
              RaisedButton(
                child: Text("Update Data"),
                onPressed: ()
                {
                  updateData(new User(750, userID));
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
      ),
    );
  }
  void writeData(String loanAmount)
  {
    User user = new User(int.parse(loanAmount), userID);
    dbRef.child("Users").child(userID).push().set(user.toJson());
  }

  void updateData(User user)
  {
    if(user != null)
    {
      dbRef.child("Users").child(user.key).set(user.toJson());
    }
  }
  void readData()
  {
    dbRef.child(userID).once().then((DataSnapshot ds)
    {
      values = ds.value;
      print(values["loanAmount"]);
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
    dbRef.child(userID).remove();
  }
  Widget showLoanAmount()
  {
    if (_userList.length > 0)
    {
      return Text(
        ("£" + _userList[0].loanAmount.toString()),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black54
        ),
      );
    }
    else
    {
      //Prompt user for first time setup
      return Text(
        ("Error"),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black54),
      );
    }
  }
  Widget showDialog()
  {
    return AlertDialog(
      title: Text("No Loan Found"),
      content: Text("Set up account?"),
      actions: <Widget>
      [
        new FlatButton(onPressed: () { writeData("500"); }, child: new Text("Submit"))
      ],
    );
  }
}