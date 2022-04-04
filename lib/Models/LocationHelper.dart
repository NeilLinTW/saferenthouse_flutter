import 'package:http/http.dart' as http;
import 'dart:convert';

class City {
  final String Name;
  final String EId;

  // City({required this.Name, required this.EId});
  City(this.Name, this.EId);

  factory City.fromJson(Map<String,dynamic> json) {
    return City(json['Name'].toString(),json['EId'].toString());
  }


}

class Town {
  final String Name;
  final String TId;

  Town({required this.Name, required this.TId});

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      TId: json['TId'],
      Name: json['Name'],
    );
  }


}


class LocationHelper {
  Future<String> loadCity() async {
    const String cityUrl = 'https://200.11235.tw/api/city/';

    final resp = await http.get(Uri.parse(cityUrl));

    return utf8.decode(resp.bodyBytes);
  }


  Future<String> loadTown(String cityId) async {
    const String townUrl = 'https://200.11235.tw/api/town/';

    final resp = await http.get(Uri.parse(townUrl + cityId));
    // print(townUrl + cityId);
    return utf8.decode(resp.bodyBytes);
  }
}