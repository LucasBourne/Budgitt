import 'package:firebase_database/firebase_database.dart';

class User
{
  String userId;
  String key;
  int loanAmount;

  User(this.loanAmount, this.userId);

  User.fromSnapshot(DataSnapshot ds)
  {
    key = ds.key;
    userId = ds.value["userId"];
    loanAmount = ds.value["loanAmount"];
  }

  toJson()
  {
    return
    {
      "loanAmount" : loanAmount,
      "userId" : userId,
    };
  }
}