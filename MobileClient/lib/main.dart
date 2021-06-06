
import 'package:covid_alert/Services/bgTaskService.dart';
import 'package:covid_alert/Services/fcm.dart';
import 'package:flutter/gestures.dart';
import 'package:covid_alert/UI/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';


import 'Helpers/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await Firebase.initializeApp();
  await PushNotificationService.initialize();
  await Permission.location.request();
  runApp(LMK());
}

class LMK extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Constants().initialize();
    Paint.enableDithering = true;
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Covid-Alert',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: splash()
    );
  }
}
