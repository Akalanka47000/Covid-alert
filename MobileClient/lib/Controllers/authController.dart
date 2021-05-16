import 'package:covid_alert/Helpers/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:covid_alert/Controllers/userController.dart';
import 'dart:convert';


Future<String> login(String url, String email, String password) async {
  print("logging in");
  try {
    Uri endpoint = Uri.parse('$url/user/login');
    var data = {
      "email": email,
      "password": password,
      "device":"Mobile"
    };

    String body = jsonEncode(data);

    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseJson["success"] == true) {
        Constants.userID=responseJson["userID"];
        String firebaseToken=await FirebaseMessaging.instance.getToken();
        var location= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        String updateStatus=await updateUser(url,firebaseToken,location.latitude,location.longitude,Constants.userID);
        if(updateStatus==null){
          await CacheService.saveJWTToken(responseJson["token"]);
          await CacheService.saveUserEmail(email);
          await CacheService.saveUserPassword(password);
          await CacheService.saveLoggedInStatus(true);
          return null;
        }else{
          return updateStatus;
        }
      } else {
        return responseJson["message"];
      }
    } else {
      return responseJson["message"];
    }
  }catch(e){
    print(e);
    return "Server didn't respond";
  }
}

Future<String> registerUser(String url, String email, String password, String name,) async {

  try {
    Uri endpoint = Uri.parse('$url/user/register');
    var data = {
      "name": name,
      "email": email,
      "password": password,
    };
    String body = jsonEncode(data);
    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson["success"] == true) {
        Constants.userID=responseJson["userID"];
        String firebaseToken=await FirebaseMessaging.instance.getToken();
        var location= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        String updateStatus=await updateUser(url,firebaseToken,location.latitude,location.longitude,Constants.userID);
        if(updateStatus==null){
          await CacheService.saveJWTToken(responseJson["token"]);
          await CacheService.saveUserEmail(email);
          await CacheService.saveUserPassword(password);
          await CacheService.saveLoggedInStatus(true);
          return null;
        }else{
          return updateStatus;
        }
      } else {
        return responseJson["message"];
      }
    } else {
      return "An error has occurred. Please try again later";
    }
  } catch (e) {
    return "Server didn't respond";
  }
}



