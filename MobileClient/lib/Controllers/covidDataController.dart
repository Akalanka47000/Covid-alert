
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<dynamic>> getCovidStats(String url,String country) async {
  print("getting covid data");
  try {
    Uri endpoint = Uri.parse('$url/country/$country');
    final response = await http.get(
      endpoint,
      headers: {"Content-Type": "application/json"},
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseJson;
    } else {
      return null;
    }
  }catch(e){
    print(e);
    return null;
  }
}