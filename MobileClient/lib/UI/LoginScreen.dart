import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:covid_alert/UI/CustomWidgets/bezierContainer.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:covid_alert/Services/authService.dart';
import 'package:covid_alert/UI/Register.dart';
import 'package:covid_alert/UI/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _entryField(String title, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Container(
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
              controller: isPassword ? _passwordController : _emailController,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(var progress) {
    return InkWell(
      onTap: () async {
        progress.show();
        String email = _emailController.text;
        String password = _passwordController.text;
        print(email);
        print(password);
        String authenticationMessage = await login(Constants.serverUrl, email, password);
        progress.dismiss();
        if (authenticationMessage == null) {
          _emailController.text = "";
          _passwordController.text = "";
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.redAccent.withAlpha(100), offset: Offset(2, 4), blurRadius: 8, spreadRadius: 2),
            ],
            //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xfffbb448), Color(0xfff7892b)])
          ),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }




  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,color: Constants.theme == "Dark" ?Colors.white:Colors.black
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
              child: Text(
                'Register',
                style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600),
              ),
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
            color: Constants.theme == "Dark" ?Colors.white:Colors.black,
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
        _entryField("Email"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ProgressHUD(
      child: Builder(builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/BG.jpg"),
                  colorFilter:  Constants.theme == "Dark" ?new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken):new ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.hardLight),
                  fit: BoxFit.cover,
                ),
              ),
          height: height,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Positioned(top: -height * .15, right: -MediaQuery.of(context).size.width * .4, child: BezierContainer()),
                Center(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: MediaQuery.of(context).size.height*0.28),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(progress),
                        // Container(
                        //   padding: EdgeInsets.symmetric(vertical: 20),
                        //   alignment: Alignment.centerRight,
                        //   child: Center(
                        //     child: GestureDetector(
                        //       onTap: () async {
                        //         progress.show();
                        //         String email = _emailController.text;
                        //         String message = await forgotPassword(Constants.serverUrl, email);
                        //         progress.dismiss();
                        //         if (message == null) {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             SnackBar(
                        //               backgroundColor: Colors.greenAccent,
                        //               content: Text(
                        //                 "An Email has been sent to the specified email address. Please check your inbox",
                        //                 style: TextStyle(
                        //                   color: Colors.black.withOpacity(0.65),
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         } else {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             SnackBar(
                        //               backgroundColor: Colors.redAccent,
                        //               content: Text(message),
                        //             ),
                        //           );
                        //         }
                        //       },
                        //       child: Text(
                        //         'Forgot Password ?',
                        //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // _divider(),
                        // _facebookButton(),
                        SizedBox(height: height * .055),
                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ),
                //Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          ),
        ));
      }),
    );
  }
}
