import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getIP() async {
  const String url = 'https://api.ipify.org/?format=json';
  final resp = await http.get(Uri.parse(url));

  // print(resp.statusCode);
  if(resp.statusCode != 200){
    return '';
  }

  var data = json.decode(utf8.decode(resp.bodyBytes));

  return data['ip'].toString();
}
