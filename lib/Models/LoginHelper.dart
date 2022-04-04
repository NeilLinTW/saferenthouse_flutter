import 'dart:convert';
import 'package:http/http.dart' as http;
import 'UserInfo.dart';

Future<UserInfo> doLogin(String name , String pwd) async {
  const String loginUrl = 'https://rentapi.11235.tw/auth/login/';
  UserInfo user = UserInfo(refresh:'',access: '');

  final resp = await http.post(
    Uri.parse(loginUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': name,'password':pwd
    }),
  );

  if(resp.statusCode == 200){
    // print("****************");
    // print(UserInfo.fromJson(jsonDecode(resp.body)));
    return UserInfo.fromJson(jsonDecode(resp.body));
  }else{
    // print(resp.statusCode);
    var error = jsonDecode(resp.body);
    user.error = error['detail'].toString();

    if(user.error.contains('No active account')){
      user.error = '沒有帳號，請註冊';
    }
    // throw Exception('發生錯誤');
    return user;
  }

}


Future<RefreshTokenInfo> doRefresh(String refresh) async {
  const String loginUrl = 'https://rentapi.11235.tw/api/token/refresh/';

  final resp = await http.post(
    Uri.parse(loginUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'refresh': refresh,
    }),
  );

  if(resp.statusCode == 200){
    // print("****************");
    // print(UserInfo.fromJson(jsonDecode(resp.body)));
    return RefreshTokenInfo.fromJson(jsonDecode(resp.body));
  }else{
    // print(resp.statusCode);
    final refreshInfo = RefreshTokenInfo(access: '');

    return refreshInfo;
    // throw Exception('發生錯誤');
  }

}