import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe_rent_house/Models/AdvInfo.dart';
import 'package:safe_rent_house/requisition.dart';
import 'Models/AdvHelper.dart';
import 'Models/DataOperator.dart';
import 'Models/DialogHelepr.dart';
import 'Models/ListviewWidget.dart';
import 'Models/LocationHelper.dart';
import 'main.dart';
import 'citydropdown.dart';

class SearchScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchScreen();

}


class _SearchScreen extends State<SearchScreen>{
  final titleVal = const Text("我要查詢");
  bool isClickSearch = false;

  String searchDDCityVal = '0';
  String searchDDTwnVal = '0';
  late Future townFuture;
  List<dynamic> cityJson = [];
  List<dynamic> townJson = [];
  List<AdvInfo> advList = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: titleVal,
            centerTitle: true,
            backgroundColor: Colors.green.shade800,
            automaticallyImplyLeading: false,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.green.shade50,
          body:  SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                InputDecorator(
                  child: FutureBuilder(future: loadCity() ,builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if(snapshot.hasData) {
                      return DropdownButton<String>(
                        value: searchDDCityVal,
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
                          DataOperator.saveData('SelectedCityVal',value ?? '');

                          setState(() {
                            searchDDCityVal = value ?? '0';
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
                InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)),),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    child:DropdownButton<String>(
                        isExpanded: false,
                        hint: const Text('選擇鄉鎮'),
                        value: searchDDTwnVal,
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                        items: townJson.map((e) {
                          return DropdownMenuItem<String>(
                              child: Text(e['Name']),
                              value: e['TId']
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          var chooseTown = townJson.where((ele) => ele['TId'].toString().contains(value ?? '')).toList();
                          String selectedTownName = chooseTown == null ? '' : chooseTown[0]['Name'];
                          DataOperator.saveData('SelectedTown',selectedTownName);
                          DataOperator.saveData('SelectedTownVal',value ?? '');

                          setState(() {
                            //   //   print('town onchange=' + (value ?? ''));
                            searchDDTwnVal  = value ?? '0';
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
                const SizedBox(height: 5),
                ElevatedButton(
                    child: const Text('查看看'),
                    style: ElevatedButton.styleFrom(fixedSize: const Size(240, 50), textStyle: const TextStyle(fontSize: 18)),
                    onPressed: () async {
                      final advInfo = AdvInfo();

                      if(searchDDCityVal == '0'){
                        // print('searchDDCityVal=' + searchDDCityVal);
                        DialogHelper.displayDialogOKCallBack(context, '訊息', '記得選縣市', '確定');
                        return;
                      }
                      if(searchDDTwnVal == '0'){
                        // print('searchDDTwnVal=' + searchDDTwnVal);
                        DialogHelper.displayDialogOKCallBack(context, '訊息', '還有選鄉鎮', '確定');
                        return;
                      }

                      isClickSearch = true;

                      String cityTxt = DataOperator.readData('SelectedCity');
                      // print('selected=' + cityTxt);
                      String townTxt = DataOperator.readData('SelectedTown');
                      // print('selected=' + townTxt);

                      advInfo.city = cityTxt;
                      advInfo.town = townTxt;

                      await doAdvSearch(advInfo).then((value){
                        setState(() {
                          advList = value;
                        });
                        // print(value);
                      });

                }),
                const SizedBox(height: 5,),
                const Divider(height: 5, thickness: 2,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [SearchResultList(advList , isClickSearch)],
                )


              ],

            )

          ),

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.green.shade800,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type:BottomNavigationBarType.fixed ,
            onTap: (idx) async {
              switch(idx){
                case 0:
                  // const String access = '';

                  // DataOperator.readData('access').then((value) {
                  //   if(access.isEmpty) {
                  //
                  //     // DialogHelper.displayDialogOKCallBack(context, '訊息', '登入後看內幕，即將前往登入頁','好，我期待很久了').then((value) {
                  //     //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                  //     // });
                  //
                  //     // showAlertDialog(context, '登入後看內幕，即將前往登入頁', "訊息" , "好，我期待很久了");
                  //   } else {
                  //     Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchScreen()));
                  //   }
                  // });

                  break;
                case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ReqScreen()));


                  break;

                case 2:
                  Navigator.popUntil(context, ModalRoute.withName('/'));

                  break;
              }

            },
            items:const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.saved_search),label: '我要查詢'),
              BottomNavigationBarItem(icon: Icon(Icons.create),label: '我要刊登'),
              BottomNavigationBarItem(icon: Icon(Icons.saved_search),label: '回首頁'),
            ],
          ),

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
        searchDDTwnVal = '0';
      });

      return result;
    }
  }
  
}

