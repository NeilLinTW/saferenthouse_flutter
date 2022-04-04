import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_rent_house/Models/AdvInfo.dart';

Future<bool> doAdvCreate(AdvInfo advInfo , String token) async {
  const String loginUrl = 'https://rentapi.11235.tw/api/v1/adv/';
  bool result = true;
  // print(token);

  final resp = await http.post(
    Uri.parse(loginUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'City': advInfo.city,
      'Town':advInfo.town,
      'IP':advInfo.IP,
      'Addr':advInfo.addr,
      'Body':advInfo.body,
      'Image1':advInfo.image1,
      'Image2':advInfo.image2,
    }),
  );

  print(resp.statusCode);
  if(resp.statusCode != 200){
    // print(resp.statusCode);
    return false;
  }

  return result;
}


Future<List<AdvInfo>> doAdvSearch(AdvInfo advInfo) async {
  const String loginUrl = 'https://rentapi.11235.tw/api/v1/adv/search/';
  const advInfoList = List<AdvInfo>;

  final resp = await http.get(
    Uri.parse(loginUrl + advInfo.city + '/' + advInfo.town),
  );

  // print(resp.statusCode);
  if(resp.statusCode != 200){

    return [];
  }

  Iterable dataList = json.decode(utf8.decode(resp.bodyBytes));

  return List<AdvInfo>.from(dataList.map((e) => AdvInfo.fromJson(e))).toList();
}


Future<AdvInfo> doAdvDetail(String id , String token) async {
  const String detailUrl = 'https://rentapi.11235.tw/api/v1/adv/detail/';
  AdvInfo advData = AdvInfo();

  final resp = await http.get(Uri.parse(detailUrl + id),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  });

  // print(resp.statusCode);
  if(resp.statusCode != 200){
    throw Exception('逾時登入');
    // return advData;
  }

  var data = json.decode(utf8.decode(resp.bodyBytes));
  advData.city = data[0]['City'].toString();
  advData.town = data[0]['Town'].toString();
  advData.addr = data[0]['Addr'].toString();
  advData.body = data[0]['Body'].toString();
  advData.image1 = data[0]['Image1'].toString();
  advData.image2 = data[0]['Image2'].toString();
  advData.CreateDate = data[0]['CreateDate'].toString();
  advData.IP = data[0]['IP'].toString();

  return advData;
}
