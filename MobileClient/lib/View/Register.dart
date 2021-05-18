import 'package:flutter/material.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:covid_alert/View/CustomWidgets/bezierContainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:covid_alert/View/LoginScreen.dart';
import 'package:covid_alert/Controllers/authController.dart';

import 'HomeScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _entryField(String title, {bool isPassword, bool isName}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Constants.theme == "Dark" ?Colors.white:Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: isName ? _nameController : (isPassword ? _passwordController : _emailController),
            obscureText: isPassword,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 1,
                ),
              ),
              focusedBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Constants.theme == "Dark" ?Colors.white:Colors.black,
                  width: 1,
                ),
              ),
              fillColor: Colors.transparent,
              filled: true,
            ),
            style: TextStyle(
              color: Constants.theme == "Dark" ?Colors.white:Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget _submitButton(var progress) {
    return GestureDetector(
      onTap: () async {
        progress.show();
        String name = _nameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        String authenticationMessage = await registerUser(Constants.serverUrl, email, password, name);
        progress.dismiss();
        if (authenticationMessage == null) {
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(authenticationMessage),
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.redAccent.withAlpha(100), offset: Offset(2, 4), blurRadius: 8, spreadRadius: 2)],
        ),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color:Constants.theme == "Dark" ? Colors.white:Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Covid',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color:Constants.theme == "Dark" ? Colors.white:Colors.black,
          ),
          children: [
            TextSpan(
              text: ' Alert',
              style: TextStyle(color: Colors.redAccent, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username", isPassword: false, isName: true),
        _entryField("Email", isPassword: false, isName: false),
        _entryField("Password", isPassword: true, isName: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            body: Container(
              height: height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/BG.jpg"),
                  colorFilter:  Constants.theme == "Dark" ?new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken):new ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.hardLight),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height*0.28),
                          _title(),
                          SizedBox(
                            height: 50,
                          ),
                          _emailPasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          _submitButton(progress),
                          //SizedBox(height: height * 0),
                          _loginAccountLabel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
