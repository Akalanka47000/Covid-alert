import 'package:background_location/background_location.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:covid_alert/Services/userService.dart';
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
        Constants.userData=responseJson["userData"];
        String firebaseToken=await FirebaseMessaging.instance.getToken();
       // var location= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        await CacheService.saveJWTToken(responseJson["token"]);
        String updateStatus=await updateFCMToken(url,firebaseToken,Constants.userData["_id"]);
        if(updateStatus==null){
          bool locationServiceStatus =  await CacheService.getLocationServiceStatus();
          if(locationServiceStatus==null){
            locationServiceStatus=false;
          }
          if(!locationServiceStatus){
            BackgroundLocation.setAndroidNotification(
              title: "Notification title",
              message: "Notification message",
              icon: "@mipmap/ic_launcher",
            );
            BackgroundLocation.setAndroidConfiguration(1000);
            BackgroundLocation.startLocationService(distanceFilter : 1);
            BackgroundLocation.getLocationUpdates((location) async{
              print(location.latitude);
              print(location.longitude);
              Constants.userData["location"]["latitude"]=location.latitude;
              Constants.userData["location"]["longitude"]=location.longitude;
              await updateLocation(url,location.latitude,location.longitude,Constants.userData["_id"]);
            });
            await CacheService.setLocationServiceStatus(true);
          }
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

Future<String> registerUser(String url, String email, String password, String name) async {

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
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseJson["success"] == true) {
        Constants.userData=responseJson["userData"];
        String firebaseToken=await FirebaseMessaging.instance.getToken();
       // var location= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        await CacheService.saveJWTToken(responseJson["token"]);
        String updateStatus=await updateFCMToken(url,firebaseToken,Constants.userData["_id"]);
        if(updateStatus==null){
          var locationUpdateStatus="";
          BackgroundLocation.setAndroidNotification(
            title: "Notification title",
            message: "Notification message",
            icon: "@mipmap/ic_launcher",
          );
          BackgroundLocation.setAndroidConfiguration(1000);
          BackgroundLocation.startLocationService(distanceFilter : 1);
          BackgroundLocation.getLocationUpdates((location) async{
            print(location.latitude);
            print(location.longitude);
            Constants.userData["location"]["latitude"]=location.latitude;
            Constants.userData["location"]["longitude"]=location.longitude;
            locationUpdateStatus=await updateLocation(url,location.latitude,location.longitude,Constants.userData["_id"]);
          });
          if(locationUpdateStatus==null){
            await CacheService.saveUserEmail(email);
            await CacheService.saveUserPassword(password);
            await CacheService.saveLoggedInStatus(true);
            await CacheService.setLocationServiceStatus(true);
            return null;
          }else{
            return locationUpdateStatus;
          }

        }else{
          return updateStatus;
        }
      } else {
        return responseJson["message"];
      }
    } else {
      return responseJson["message"];
    }
  } catch (e) {
    return "Server didn't respond";
  }
}



