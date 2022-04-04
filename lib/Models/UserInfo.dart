// https://javiercbk.github.io/json_to_dart/

class UserInfo {
  final int username = 0;
  final String password = '';
  final String refresh;
  final String access;
  late  String error = '';

  UserInfo({required this.refresh, required this.access});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      refresh: json['refresh'],
      access: json['access'],
    );
  }
}

class RegisterInfo {
  String? username;
  String? email;

  RegisterInfo({ this.username , this.email });

  RegisterInfo.fromJson(Map<String,dynamic> data){
    username = data['username'];
    email = data['email'];
  }

}


class RefreshTokenInfo {
  String access = '';

  RefreshTokenInfo({ required this.access });
  RefreshTokenInfo.fromJson(Map<String , dynamic> token){
    access = token['access'] ?? '';
  }

}