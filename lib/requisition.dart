import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safe_rent_house/Models/UserInfo.dart';
import 'package:safe_rent_house/search.dart';
import 'Models/IPHelper.dart';
import 'Models/LocationHelper.dart';
import 'Models/LoginHelper.dart';
import 'Models/AdvHelper.dart';
import 'Models/AdvInfo.dart';
import 'Models/DataOperator.dart';
import 'Models/DialogHelepr.dart';

class ReqScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ReqScreen();

}

class _ReqScreen extends State<ReqScreen> {
  // const ReqScreen({Key? key}) : super(key: key);
  String _dropdownValue = '0'; //'eGNrNnZuN2hkaTlndWZqZej6AFXSGL1bbd1ZrabjKOw=';
  String _dropdownTownVal = '0'; //'''eGNrNnZuN2hkaTlndWZqZej6AFXSGL1bbd1ZrabjKOw=';
  late Future townFuture;
  List<dynamic> cityJson = [];
  List<dynamic> townJson = [];
  final address = TextEditingController();
  final imgUrl1 = TextEditingController();
  final imgUrl2 = TextEditingController();
  final story = TextEditingController();

  @override
  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("我要刊登"),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green.shade50,
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Text('請於10分鐘內填完 避免逾時重新登入' , style: TextStyle(color: Colors.black , fontSize: 18),),
              const SizedBox(height: 10),
              InputDecorator(
                child: FutureBuilder(future: loadCity() ,builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if(snapshot.hasData) {
                    return DropdownButton<String>(
                      value: _dropdownValue,
                      //elevation: 5,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      items: snapshot.data?.map((e) {
                        return DropdownMenuItem<String>(
                            child: Text(e['Name']),
                            value: e['EId']
                        );
                      }).toList(),
                      hint: const Text(
                        "選擇縣市",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      onChanged: (String? value) {
                        var chooseCity = snapshot.data?.where((ele) => ele['EId'].toString().contains(value ?? '')).toList();
                        String selectedCityName = chooseCity == null ? '' : chooseCity[0]['Name'];
                        DataOperator.saveData('SelectedCity',selectedCityName);

                        setState(() {
                          _dropdownValue = value ?? '0';
                          townJson = [];

                          loadTown(value ?? '0');
                        });
                      },
                    );
                  }else{
                    return const SizedBox(child: Center(child: CircularProgressIndicator(),),height: 20,width: 20,);
                  }
                },

                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 5),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),),
                  contentPadding: EdgeInsets.all(10),
                ),
                child:DropdownButton<String>(
                        isExpanded: false,
                        hint: const Text('選擇鄉鎮'),
                        value: _dropdownTownVal,
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        items: townJson.map((e) {
                          return DropdownMenuItem<String>(
                              child: Text(e['Name']),
                              value: e['TId']
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          var chooseTown = townJson.where((ele) => ele['TId'].toString().contains(value ?? '')).toList();
                          String selectedTownName = (chooseTown == null ? '' : chooseTown[0]['Name'].toString());
                          DataOperator.saveData('SelectedTown',selectedTownName);

                          setState(() {
                          //   //   print('town onchange=' + (value ?? ''));
                            _dropdownTownVal = value ?? '0';
                            // print('onchange _dropdownTownVal=' + _dropdownTownVal);
                            // print('value=' + (value ?? 'empty'));
                          });
                        }
                    )
                  // else{
                  //   // throw Exception("No Town List");
                  //   print('CircularProgressIndicator');
                  //   return const SizedBox(child: Center(child: CircularProgressIndicator(),),height: 20,width: 20,);
                  // }

              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '輸入地址(不含縣市，例如:中山路一段9999號)',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text('圖片網址為您與房東的對話和租屋合約(必要)'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: imgUrl1,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '輸入圖片網址1 (限 google drive) ',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: imgUrl2,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '輸入圖片網址2 (限 google drive)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: story,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '說明房東怎麼了(限200字，請勿輸入網址)',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('刊登，大人幫我主持公道啊'),
                style: ElevatedButton.styleFrom(fixedSize: const Size(240, 50)),
                onPressed: () async {
                  String refresh = '' , access = '' , ip = '';
                  final advInfo = AdvInfo();

                  String cityVal = DataOperator.readData('SelectedCity');
                  // print('selected=' + cityVal);

                  String townVal = DataOperator.readData('SelectedTown');
                  // print('selected=' + townVal);


                  if(address.text.isEmpty){
                    DialogHelper.displayDialogOKCallBack(context, '錯誤', '地址必填', '確定');

                    return;
                  }
                  else {
                    if(address.text.length < 5){
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '地址長度太短', '確定');

                      return;
                    }
                  }


                  if(imgUrl1.text.isEmpty){
                    DialogHelper.displayDialogOKCallBack(context, '錯誤', '圖片網址1必填', '確定');

                    return;
                  }
                  else{
                    if(!imgUrl1.text.toLowerCase().contains('google')){
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '圖片網址1請用google硬碟分享圖片', '確定');

                      return;
                    }
                  }

                  if(imgUrl2.text.trim().length > 10){
                    if(imgUrl2.text.toLowerCase().indexOf('google') == 0){
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '圖片網址2請用google硬碟分享圖片', '確定');

                      return;
                    }
                  }
                  // if(imgUrl2.text.isEmpty){
                  //   DialogHelper.displayDialogOKCallBack(context, '錯誤', '圖片網址2必填', '確定');
                  //
                  //   return;
                  // }
                  // else{
                  //   if(imgUrl2.text.toLowerCase().indexOf('google') == 0){
                  //     DialogHelper.displayDialogOKCallBack(context, '錯誤', '圖片網址2請用google硬碟分享圖片', '確定');
                  //
                  //     return;
                  //   }
                  // }

                  if(story.text.isEmpty){
                    DialogHelper.displayDialogOKCallBack(context, '錯誤', '說明房東怎麼了必填', '確定');

                    return;
                  }
                  else {
                    if(story.text.length < 10){
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '說明房東怎麼了長度太短', '確定');

                      return;
                    }
                    if(story.text.length > 200){
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '說明房東怎麼了超過200字', '確定');

                      return;
                    }
                  }

                  refresh = DataOperator.readData('refresh');
                  await doRefresh(refresh).then((value) {
                    access = value.access;
                    // print('new access token=' + value.access);
                    DataOperator.saveData('access', 'value.access');
                  });

                  await getIP().then((value) {
                    ip = value;
                  });

                  if (ip.isEmpty) {
                    DialogHelper.displayDialogOKCallBack(context, '錯誤', '請重開程式', '確定');
                    return;
                  }

                  advInfo.city = cityVal;
                  advInfo.town = townVal;
                  advInfo.IP = ip;
                  advInfo.addr = address.text.trim();
                  advInfo.image1 = imgUrl1.text.trim();
                  advInfo.image2 = imgUrl2.text.trim().isEmpty ? 'http' : imgUrl2.text.trim();
                  advInfo.body = story.text.trim();

                  await doAdvCreate(advInfo , access).then((value) {
                    // print('create=' + value.toString());
                    if(value = true) {
                      // DialogHelper.displayDialogOKCallBack(context, '訊息', '新增完成，審核中', '確定');

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("新增完成，審核中"),
                            duration: Duration(milliseconds: 1800),
                          ));
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }
                    else{
                      DialogHelper.displayDialogOKCallBack(context, '錯誤', '發生錯誤，請稍後再試', '確定');
                    }

                  });

                },

              ),
              const SizedBox(height: 5,),
              const Text('刊登後無法修改，審核通過會公開在「我要查詢」'),
              const Text('基於法律建議，審核後刊登將顯示您的IP'),
              const Text('您需特別注意IP問題'),
              const Text('任何問題請回首頁「聯絡我們」填寫問題單'),
              const SizedBox(height: 3,),
            ],

          )
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green.shade800,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type:BottomNavigationBarType.fixed,
          onTap: (idx) async {
            switch(idx){
              case 0:
                const String access = '';
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchScreen()));

                break;

              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReqScreen()));

                break;

              case 2:
                Navigator.popUntil(context, ModalRoute.withName('/'));

                break;
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.saved_search),label: '我要查詢'),
            BottomNavigationBarItem(icon: Icon(Icons.create),label: '我要刊登'),
            BottomNavigationBarItem(icon: Icon(Icons.saved_search),label: '回首頁'),
          ]
      ),
    );
  }

  Future<List<dynamic>> loadCity() async {
    final location = LocationHelper();
    String cityJsonStr = '';
    String value = DataOperator.readData('City');
    if(value.isEmpty){
      await location.loadCity().then((data) {
        DataOperator.saveData('City', data);
        cityJsonStr = data;
      });
    }
    else{

      cityJsonStr = value;
    }

    if(cityJsonStr.isEmpty) {
      return [];
    }
    else{
      // print('correct');
      List<dynamic> result = json.decode(cityJsonStr);
      result.insert(0, { "Id":"", "Name":"選擇縣市","EId":"0" });
      return result;
    }
  }

  Future<List<dynamic>> loadTown(String cityId) async {
    final location = LocationHelper();
    String townJsonStr = '';
    // print('cityId ' + cityId);

    if(cityId == "0"){
      return [];
    }

    await location.loadTown(cityId).then((data) {
      // print('data=' + data);
      townJsonStr = data;
    });

    if(townJsonStr.isEmpty) {
      return [];
    }
    else{
      // print('town correct');
      List<dynamic> result = json.decode(townJsonStr);
      result.insert(0, { "Id":"", "Name":"選擇鄉鎮","TId":"0" });

      setState(() {
        townJson = result;
        _dropdownTownVal = '0';
      });

      return result;
    }
  }

}