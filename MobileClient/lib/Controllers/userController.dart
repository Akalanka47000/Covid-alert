import 'package:covid_alert/Helpers/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:covid_alert/Helpers/CacheService.dart';
import 'dart:convert';

Future<String> updateUser(String url, String fcmToken, double latitude, double longitude,String userID) async {
  print("updating user");
  try {
    Uri endpoint = Uri.parse('$url/user/location/$userID');
    var data = {
      "firebaseToken":fcmToken,
      "location":{
        "latitude": latitude,
        "longitude":longitude
      }
    };

    String body = jsonEncode(data);

    final response = await http.put(
      endpoint,
      headers: {"Content-Type": "application/json"},
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