import 'package:flutter/material.dart';

class TownDropDown extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => BuildTownDropDown();

}

class BuildTownDropDown extends State<TownDropDown> {
  // bool isDropdownOpened;
  late String selectedCity = '0';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color:Colors.white70
        ),

        child: FormField<String>(
          builder: (FormFieldState<String> state){
            return InputDecorator(
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCity,
                  onChanged: (val){
                    setState(() {
                      selectedCity = val ?? '';
                    });
                  },
                  items: [],
                ),
              ),
            );
          },


        )

    );
  }

  List<DropdownMenuItem<String>> loadTown() {
    List<DropdownMenuItem<String>> data = [];

    data.add(const DropdownMenuItem(child: Text('基隆市'),value: '0',));
    data.add(const DropdownMenuItem(child: Text('台北市'),value: '1',));
    data.add(const DropdownMenuItem(child: Text('新北市'),value: '2',));
    data.add(const DropdownMenuItem(child: Text('桃園市'),value: '3',));
    data.add(const DropdownMenuItem(child: Text('新竹市'),value: '4',));
    data.add(const DropdownMenuItem(child: Text('新竹縣'),value: '5',));
    data.add(const DropdownMenuItem(child: Text('台中市'),value: '6',));
    data.add(const DropdownMenuItem(child: Text('彰化縣'),value: '7',));
    data.add(const DropdownMenuItem(child: Text('雲林縣'),value: '8',));
    data.add(const DropdownMenuItem(child: Text('嘉義市'),value: '9',));
    data.add(const DropdownMenuItem(child: Text('嘉義縣'),value: '10',));
    data.add(const DropdownMenuItem(child: Text('台南市'),value: '11',));
    data.add(const DropdownMenuItem(child: Text('高雄市'),value: '12',));
    data.add(const DropdownMenuItem(child: Text('屏東縣'),value: '13',));
    data.add(const DropdownMenuItem(child: Text('台東縣'),value: '14',));
    data.add(const DropdownMenuItem(child: Text('花蓮縣'),value: '15',));

    return data;
  }

}

