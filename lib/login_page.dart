import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'first_screen.dart';
import 'sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      backgroundColor: backgroundColour,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            _logoImage(),
            SizedBox(height: 100),
            _emailField(),
            SizedBox(height: 15),
            _passwordField(),
            SizedBox(height: 5),
            _signInFunctions(),
          ],
        ),
      ),
    );
  }

  Color accentColour = Color.fromRGBO(2, 195, 154, 1);
  Color backgroundColour = Color.fromRGBO(19, 21, 21, 1);

  Padding _signInFunctions()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>
        [
          _emailSignInFunctions(),
          _otherSignIn(),
        ],
      ),
    );
  }

  Row _emailSignInFunctions()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>
      [
        _signInButton(),
        SizedBox(width: 10),
        _signUpButton(),
      ],
    );
  }

  Image _logoImage()
  {
    return Image(
      image: AssetImage("assets/LogoText.png"),
      width: 200,
    );
  }

  RaisedButton _signUpButton()
  {
    return RaisedButton(
      child: Text(
        "Sign up", 
        style: GoogleFonts.karla(),
      ),
      onPressed: ()
      {
        signUpEmailPassword(emailController.text, passwordController.text);
        emailController.clear();
        passwordController.clear();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: accentColour,
      textColor: backgroundColour,
    );
  }

  RaisedButton _signInButton()
  {
    return RaisedButton(
      child: Text(
        "Sign in",
        style: GoogleFonts.karla(),
      ),
      onPressed: ()
      {
        signInEmailPassword(emailController.text.trim(), passwordController.text.trim()).whenComplete(()
        {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) 
            {
             return FirstScreen();
            }
          ));
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: accentColour,
      textColor: backgroundColour,
    );
  }

  Container _signInGoogleButton() 
  {
    return Container(
      alignment: Alignment.centerRight,
      child: RaisedButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Image(
              image: AssetImage("assets/GoogleLogo.png"),
              height: 20,
            ),
            SizedBox(width: 10),
            Text(
              "Sign in with Google",
              style: GoogleFonts.karla(),
            ),
          ]
        ),
        onPressed: () 
        {
          signInWithGoogle().whenComplete(()
          {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) 
              {
                return FirstScreen();
              },
            ));
         });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.white,
        textColor: backgroundColour,
      ),
    );
  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Padding _emailField()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextField(
        style: GoogleFonts.karla(color: accentColour),
        controller: emailController,
        cursorColor: accentColour,
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: GoogleFonts.karla(color: accentColour),
          icon: Icon(Icons.email, color: accentColour,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: accentColour, 
              width: 3.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: accentColour, 
              width: 3.0,
            ),
          )
        ),
        obscureText: false,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  ExpansionTile _otherSignIn()
  {
    return ExpansionTile(
      backgroundColor: Colors.transparent,
      title: Text(
        "Other sign in options",
        textAlign: TextAlign.end,
        style: GoogleFonts.karla(
          color: accentColour,
          fontSize: 15,
        ),
      ),
      children: <Widget>
      [
        _signInGoogleButton(),
      ],
    );
  }

  Padding _passwordField()
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextField(
        style: GoogleFonts.karla(color: accentColour),
        controller: passwordController,
        cursorColor: accentColour,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: GoogleFonts.karla(color: accentColour),
          icon: Icon(Icons.lock, color: accentColour,),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: accentColour, 
              width: 3.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: accentColour, 
              width: 3.0,
            ),
          )
        ),
        obscureText: true,
        autocorrect: false,
        keyboardType: TextInputType.text,
      ),
    );
  }
}