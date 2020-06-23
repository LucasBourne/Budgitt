import 'package:flutter/material.dart';
import 'login_page.dart';

void main() => runApp(MyApp());

Map<int, Color> colour =
{
  50:Color.fromRGBO(186, 104, 200, .1),
  100:Color.fromRGBO(186, 104, 200, .2),
  200:Color.fromRGBO(186, 104, 200, .3),
  300:Color.fromRGBO(186, 104, 200, .4),
  400:Color.fromRGBO(186, 104, 200, .5),
  500:Color.fromRGBO(186, 104, 200, .6),
  600:Color.fromRGBO(186, 104, 200, .7),
  700:Color.fromRGBO(186, 104, 200, .8),
  800:Color.fromRGBO(186, 104, 200, .9),
  900:Color.fromRGBO(186, 104, 200, 1),
};

MaterialColor customColour = MaterialColor(0xFFBA68C8, colour);

class MyApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgitt',
      theme: ThemeData(
        unselectedWidgetColor: Colors.purple[300],
        accentColor: Colors.purple[300],
        primarySwatch: customColour,
        hintColor: Colors.purple[300],
      ),
      home: LoginPage(false),
    );
  }
}