import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_rent_house/Models/AdvInfo.dart';
import 'Models/DataOperator.dart';
import 'Models/DialogHelepr.dart';
import 'Models/IPHelper.dart';
import 'package:safe_rent_house/Models/RateHelper.dart';

import 'Models/Rate.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RateScreen();

}


class _RateScreen extends State<RateScreen>{
  // const RateScreen({Key? key}) : super(key: key);
  late  int selectedVal = 3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("我要評分"),
          backgroundColor: Colors.green.shade800,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.green.shade50,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              // const Center(child: Text('請給我們評分' , style:TextStyle(fontSize: 20) , textAlign: TextAlign.center,),),
              // const SizedBox(height: 30),
              const Center(child: Text('3分為最優質APP' , style:TextStyle(fontSize: 20) , textAlign: TextAlign.center,),),
              const SizedBox(height: 10),
              const Center(child: Text('2分為普通' , style:TextStyle(fontSize: 20) , textAlign: TextAlign.center,),),
              const SizedBox(height: 10),
              const Center(child: Text('1分為待改善' , style:TextStyle(fontSize: 20) , textAlign: TextAlign.center,),),
              const SizedBox(height: 40),
              SizedBox(
                width: 90,
                height: 65,
                child: DropdownButton(
                  value: selectedVal,
                  hint: const Text('請選擇'),
                  style: const TextStyle(fontSize: 20,color: Colors.black),
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem(child: Text('1分'),value: 1,),
                    DropdownMenuItem(child: Text('2分'),value: 2,),
                    DropdownMenuItem(child: Text('3分'),value: 3,),


                  ],
                  onChanged: (int? value) {
                    setState((){
                      selectedVal = value ?? 3;
                    });
                  },

                ),
              ),
              const SizedBox(height: 10),
              Container(
                  height: 50,
                  width: 100,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green,
                    shadowColor: Colors.greenAccent,
                      child: ElevatedButton(
                        onPressed: () async {
                          String ip = '';
                          Rate rate = Rate();
                          DateTime dateToday = DateTime.now();
                          String today = dateToday.toString().substring(0,10);
                          String saveRateDate = '';
                          // print('selectedVal=' + selectedVal.toString());

                          saveRateDate = DataOperator.readData('RateDate');

                          if(saveRateDate == today){
                            DialogHelper.displayDialogOKCallBack(context, '訊息', '您已經評分', '確定');
                            return;
                          }

                          await getIP().then((value) {
                            ip = value;
                          });

                          if (ip.isEmpty) {
                            DialogHelper.displayDialogOKCallBack(context, '錯誤', '請重開程式', '確定');
                            return;
                          }

                          // print(ip);
                          rate.IPAddr = ip;
                          rate.Val = selectedVal.toString();

                          await doRate(rate).then((value) {
                            if(value == '0') {
                              DialogHelper.displayDialogOKCallBack(context, '評分錯誤', '請重開程式', '確定');
                            }else{
                              DataOperator.saveData('RateDate', today);
                            }
                          });

                          DialogHelper.displayDialogOKCallBack(context, '訊息', '感謝評分', '確定');
                        },
                        child: const Text('送出',style: TextStyle(fontSize: 18),),
                      ),
                  )

              ),
            ],

          ),
        ),

      ),


    );
  }


}
