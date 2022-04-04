import 'dart:convert';
import 'package:flutter/material.dart';
import 'Models/DataOperator.dart';
import 'Models/LocationHelper.dart';


class CityDropDown extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BuildCityDropDown();


}



class BuildCityDropDown extends State<CityDropDown> {
  late String selectedCity = '0';
  String dropdownValue = '';
  List<DropdownMenuItem<String>>? items;

  @override
  void initState(){
    super.initState();

    loadItems();
  }


  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>>? items = [];
    List<City> cityList = [];
    DropdownButton<String> dropdownButton ;
    String dropdownValue = '';

    // DataOperator.readData('City').then((value) {
    //   if(value.isEmpty){
    //     Location.loadCity().then((data) {
    //       DataOperator.saveData('City', data);
    //       // print('location' + data);
    //     });
    //   }
    //
    //   print('from SP');
    //
    //   Iterable list = json.decode(value);
    //   cityList = List<City>.from(list.map((e) => City.fromJson(e)));
    //
    //   items = cityList.map((e) {
    //     // print(e.Name);
    //     return DropdownMenuItem(
    //       child: Text(e.Name) , value: e.EId,
    //     );
    //   }).toList();
    //
    // });

    // print('before list = ' + cityList.length.toString());
    // Future.delayed(const Duration(milliseconds: 1800));

    // print('list = ' + items!.length.toString());

    // dropdownButton = DropdownButton<String>(
    //   value: dropdownValue,
    //
    //   style: const TextStyle(color: Colors.deepPurple),
    //   // underline: Container(
    //   //   height: 60,
    //   //   width: 350,
    //   // ),
    //   onChanged: (String? newValue) {
    //     setState(() {
    //       dropdownValue = newValue!;
    //     });
    //   },
    //   items: items
    //
    // );

    // return dropdownButton;

    return FutureBuilder(
        future:loadItems(),
        builder: (context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
          // if(snapshot.hasData) {
            return DropdownButton<String>(
                value: dropdownValue,
                style: const TextStyle(color: Colors.deepPurple),
                // underline: Container(
                //   height: 60,
                //   width: 350,
                // ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: items

            );

        }

    );

  }





  // Future<List<DropdownMenuItem<String>>?>
  loadItems() async {

    List<City> cityList = [];
    DropdownButton<String> dropdownButton ;
    String dropdownValue = '';

    // await DataOperator.readData('City').then((value) {
    //   if(value.isEmpty){
    //     Location.loadCity().then((data) {
    //       DataOperator.saveData('City', data);
    //       // print('location' + data);
    //     });
    //   }
    //
    //   // print(value);
    //   // print('from SP');
    //
    //   setState(() {
    //     // print('setState');
    //     Iterable list = json.decode(value);
    //     print(list);
    //
    //   });
    //
    //
    //
    // });

  }


}





  // List<DropdownMenuItem<String>> loadCity() {
  //   List<DropdownMenuItem<String>> data = [];
  //
  //   data.add(const DropdownMenuItem(child: Text('基隆市'),value: '0',));
  //   data.add(const DropdownMenuItem(child: Text('台北市'),value: '1',));
  //   data.add(const DropdownMenuItem(child: Text('新北市'),value: '2',));
  //   data.add(const DropdownMenuItem(child: Text('桃園市'),value: '3',));
  //   data.add(const DropdownMenuItem(child: Text('新竹市'),value: '4',));
  //   data.add(const DropdownMenuItem(child: Text('新竹縣'),value: '5',));
  //   data.add(const DropdownMenuItem(child: Text('台中市'),value: '6',));
  //   data.add(const DropdownMenuItem(child: Text('彰化縣'),value: '7',));
  //   data.add(const DropdownMenuItem(child: Text('雲林縣'),value: '8',));
  //   data.add(const DropdownMenuItem(child: Text('嘉義市'),value: '9',));
  //   data.add(const DropdownMenuItem(child: Text('嘉義縣'),value: '10',));
  //   data.add(const DropdownMenuItem(child: Text('台南市'),value: '11',));
  //   data.add(const DropdownMenuItem(child: Text('高雄市'),value: '12',));
  //   data.add(const DropdownMenuItem(child: Text('屏東縣'),value: '13',));
  //   data.add(const DropdownMenuItem(child: Text('台東縣'),value: '14',));
  //   data.add(const DropdownMenuItem(child: Text('花蓮縣'),value: '15',));
  //
  //   return data;
  // }



