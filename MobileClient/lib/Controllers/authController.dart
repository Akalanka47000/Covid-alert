import 'package:covid_alert/Helpers/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:covid_alert/Helpers/CacheService.dart';
import 'dart:convert';


Future<String> login(String url, String email, String password) async {
  print("logging in");
  try {
    Uri endpoint = Uri.parse('$url/user/login');
    var data = {
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
        await CacheService.saveJWTToken(responseJson["token"]);
        Constants.userID=responseJson["userID"];
        await CacheService.saveUserEmail(email);
        await CacheService.saveUserPassword(password);
        await CacheService.saveLoggedInStatus(true);
        return null;
      } else {
        return responseJson["message"];
      }
    } else {
      return "An error has occurred. Please try again later";
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
        await CacheService.saveJWTToken(responseJson["token"]);
        Constants.userID=responseJson["userID"];
        await CacheService.saveUserEmail(email);
        await CacheService.saveUserPassword(password);
        await CacheService.saveLoggedInStatus(true);
        return null;
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



