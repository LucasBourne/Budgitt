import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_page.dart';
import 'sign_in.dart';

class FirstScreen extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.reference();

  @override

  Widget build(BuildContext context) {
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
              /*
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              */
              SizedBox(height: 20),
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
                  writeData();
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
                  updateData();
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
  void writeData()
  {
    dbRef.child(userID).set
    ({
      "User ID" : userID,
      "Loan Amount" : 500,
      "Rent Amount" : 200,
      "Move In Date" : "01/01/2020",
      "Move Out Date" : "02/10/2020",
      "Spend This Week" : 10,
      "Spend This Month" : 50,
      "Spend This Year" : 150,
    });
  }
  void updateData()
  {
    dbRef.child(userID).update
    ({
      "Loan Amount" : 750,
    });
  }
  void readData()
  {
    dbRef.once().then((DataSnapshot dataSnapshot)
    {
      print(dataSnapshot.value);
    });
  }
  void deleteData()
  {
    dbRef.child(userID).remove();
  }
}