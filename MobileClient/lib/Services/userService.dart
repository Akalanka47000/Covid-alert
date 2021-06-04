import 'package:covid_alert/Helpers/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:covid_alert/Helpers/CacheService.dart';
import 'dart:convert';

Future<String> updateFCMToken(String url, String fcmToken,String userID) async {
  print("updating user");
  try {
    Uri endpoint = Uri.parse('$url/user/update/$userID');
    String jwtToken = await CacheService.getJWTToken();
    var data = {
      "firebaseToken":fcmToken,
    };

    String body = jsonEncode(data);

    final response = await http.patch(
      endpoint,
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $jwtToken'},
      body: body,
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      return responseJson["message"];
    }
  }catch(e){
    print(e);
    return "Server didn't respond";
  }
}

Future<String> updateLocation(String url,double latitude, double longitude,String userID) async {
  print("updating user");
  try {
    Uri endpoint = Uri.parse('$url/user/update/$userID');
    String jwtToken = await CacheService.getJWTToken();
    var data = {
      "location":{
        "latitude": latitude,
        "longitude":longitude
      }
    };

    String body = jsonEncode(data);

    final response = await http.patch(
      endpoint,
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $jwtToken'},
      body: body,
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      return responseJson["message"];
    }
  }catch(e){
    print(e);
    return "Server didn't respond";
  }
}

Future<String> setNotificationStatus(String url, bool status,String userID) async {
  print("setting notification status");
  try {
    Uri endpoint = Uri.parse('$url/user/update/$userID');
    String jwtToken = await CacheService.getJWTToken();
    var data = {
      "notifications":status,
    };

    String body = jsonEncode(data);

    final response = await http.patch(
      endpoint,
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $jwtToken'},
      body: body,
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      return responseJson["message"];
    }
  }catch(e){
    print(e);
    return "Server didn't respond";
  }
}

Future<String> updatePositiveStatus(String url, bool status,String userID) async {
  print("updating positive status");
  try {
    Uri endpoint = Uri.parse('$url/user/update/$userID');
    String jwtToken = await CacheService.getJWTToken();
    var data = {
      "positiveStatus":status,
    };

    String body = jsonEncode(data);

    final response = await http.patch(
      endpoint,
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $jwtToken'},
      body: body,
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "Successfully Updated";
    } else {
      return responseJson["message"];
    }
  }catch(e){
    print(e);
    return "Server didn't respond";
  }
}