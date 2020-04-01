  import 'package:firebase_database/firebase_database.dart';
  import 'sign_in.dart';

  final dbRef = FirebaseDatabase.instance.reference();
  
  void dbWrite(int loanAmount)
  {
    dbRef.child(userID).set(
      {
        "name" : name,
        "loanAmount" : loanAmount,
      }
    );
  }
  void dbUpdate(int loanAmount)
  {
      dbRef.child(userID).update(
      {
        "loanAmount" : loanAmount,
      }
    );
  }