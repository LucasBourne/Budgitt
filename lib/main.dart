import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        unselectedWidgetColor: Color.fromRGBO(2, 195, 154, 1),
        accentColor: Color.fromRGBO(2, 195, 154, 1),
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}