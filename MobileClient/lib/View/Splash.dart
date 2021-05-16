import 'dart:async';
import 'package:covid_alert/Controllers/authController.dart';
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid_alert/View/LoginScreen.dart';
import 'package:covid_alert/Helpers/Constants.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  Future<bool> checkLoginStatus() async {
    Timer(Duration(seconds: 6), () async {
      bool status = await CacheService.getLoggedInStatus();
      if(status==true){

      }else{
        status=false;
      }
      return status;
    });
  }


  loginProcedure(BuildContext context)async{
    String email=await CacheService.getUserEmail();
    String password=await CacheService.getUserPassword();
    String authMsg=await login(Constants.serverUrl, email, password);
    if(authMsg==null){
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => HomeScreen()));
    }

  }

splashContent(){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding:  EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height*0.02,),
        child: Container(
          width: MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.width*0.85:MediaQuery.of(context).size.height*0.6,
          height:MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.width*0.85:MediaQuery.of(context).size.height*0.6,
          child: Image(
            image: AssetImage("assets/images/covid.png"),
          ),
        ),
      ),
      SpinKitDoubleBounce(
        color: Color(0xFF57beff),
        size: MediaQuery.of(context).orientation == Orientation.portrait?MediaQuery.of(context).size.height*0.123:MediaQuery.of(context).size.height*0.175,
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data==true){
            loginProcedure(context);
            return splashContent();
          }else{
            return LoginScreen();
          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return splashContent();
        } else {
          return splashContent();
        }
      },
    );

  }
}

