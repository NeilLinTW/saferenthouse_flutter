import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_rent_house/Models/Rate.dart';

Future<Rate> doRate(Rate rate) async {
  const String loginUrl = 'https://rentapi.11235.tw/api/v1/adv/rate/';
  Rate rateData = Rate();

  final resp = await http.post(
    Uri.parse(loginUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'IPAddr': rate.IPAddr,
      'Val':rate.Val,
    }),
  );

  // print(resp.statusCode);
  if(resp.statusCode != 200){
    rateData.Id = '0';

    return rate;
  }

  var data = json.decode(utf8.decode(resp.bodyBytes));
  rateData.Id = data[0]['Id'].toString();

  return rateData;
}