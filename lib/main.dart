import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

Map<int, Color> colour =
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};

MaterialColor customColour = MaterialColor(0xFF02C39A, colour);

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        unselectedWidgetColor: Color.fromRGBO(2, 195, 154, 1),
        accentColor: Color.fromRGBO(2, 195, 154, 1),
        primarySwatch: customColour,
        hintColor: Color.fromRGBO(2, 195, 154, 1),
      ),
      home: LoginPage(),
    );
  }
}