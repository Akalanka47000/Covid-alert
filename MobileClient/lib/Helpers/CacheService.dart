import 'package:shared_preferences/shared_preferences.dart';

class CacheService{


  static saveJWTToken(String token)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("jwtToken", token);
  }

  static Future<String> getJWTToken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("jwtToken");
  }

  static saveUserId(String id)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userId", id);
  }
  static Future<String> getUserId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userId");
  }

  static saveUserRole(String userRole)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userRole", userRole);
  }

  static Future<String> getUserRole() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userRole");
  }


  static saveUserEmail(String email)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userEmail", email);
  }
  static Future<String> getUserEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userEmail");
  }

  static saveUserPassword(String password)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userPassword", password);
  }
  static Future<String> getUserPassword() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("userPassword");
  }


  static saveLoggedInStatus(bool loggedIn)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("loggedIn", loggedIn);
  }

  static Future<bool> getLoggedInStatus() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("loggedIn");
  }

  static setTheme(String themeName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("theme", themeName);
  }
}