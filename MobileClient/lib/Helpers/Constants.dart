

import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static final String serverUrl = "http://ec2-13-213-51-110.ap-southeast-1.compute.amazonaws.com:8000";
  static final String covidServerUrl = "https://api.covid19api.com";
  static String userID = "";
  static bool notificationStatus = true;
  static bool localStats=true;
  static String theme ;

  void initialize()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    theme=prefs.getString('theme');
    if(theme==null||theme==""){
      theme="Dark";
    }
  }


}