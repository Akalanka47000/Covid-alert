import 'dart:async';

import 'package:covid_alert/Services/bgTaskService.dart';
import 'package:covid_alert/Services/fcm.dart';
import 'package:flutter/gestures.dart';
import 'package:covid_alert/UI/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Helpers/Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await Firebase.initializeApp();
  await PushNotificationService.initialize();
  await Permission.bluetooth.request();
  await Permission.bluetooth.request();
  await Permission.location.request();
  final flutterReactiveBle = FlutterReactiveBle();
  flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency,requireLocationServicesEnabled: false).listen((device) {
    print(device.id+device.rssi.toString());
  }, onError: (error) {
    print(error);
  });
   //final isolate = await FlutterIsolate.spawn(isolate1, "hello");
  // isolate.kill();

  runApp(LMK());

}
void isolate1(String arg) async  {

  //final isolate = await FlutterIsolate.spawn(isolate2, "hello2");

  // FlutterStartup.startupReason.then((reason){
  //   print("Isolate1 $reason");
  // });

  // FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  // await _bluetooth.requestPermissions();
  // await _bluetooth.startScan(pairedDevices: false);
  //
  // _bluetooth.devices.listen((device) {
  //   print(device.name + '(${device.address})\n');
  // });

  Timer.periodic(Duration(seconds:5),(timer)=>print("Timer Running From Isolate 1"));
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
