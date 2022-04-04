
class AdvInfo {
  late String city = '';
  late String town = '';
  late String addr = '';
  late String body = '';
  late String image1 = '';
  late String image2 = '';
  late String Id;
  late String CreateDate;
  late String IP;

  AdvInfo();

  factory AdvInfo.fromJson(Map<String, dynamic> json) {
    final advInfo = AdvInfo();
    advInfo.city = json['City'];
    advInfo.town = json['Town'];
    advInfo.addr = json['Addr'];
    advInfo.body = json['Body'];
    advInfo.image1 = json['Image1'];
    advInfo.image2 = json['Image2'].toString().replaceAll('http', '');
    advInfo.Id = json['Id'].toString();
    advInfo.CreateDate = json['CreateDate'];
    advInfo.IP = json['IP'] == Null ? '' : json['IP'].toString();

    return advInfo;
  }

}
