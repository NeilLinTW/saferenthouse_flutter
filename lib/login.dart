import 'dart:convert';
import 'dart:developer';
import 'package:safe_rent_house/main.dart';
import 'package:safe_rent_house/mydata.dart';
import 'package:safe_rent_house/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/DialogHelepr.dart';
import 'Models/UserInfo.dart';
import 'Models/DataOperator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/ValidatorHelper.dart';
import 'join.dart';
import 'Models/LoginHelper.dart';

class LoginScreen extends StatelessWidget{
  LoginScreen({Key? key}) : super(key: key);
  final String loginUrl = 'https://rentapi.11235.tw/auth/login/';
  final accController = TextEditingController();
  final pwdController = TextEditingController();
  Future<UserInfo>? userObj;

  @override
  Widget build(BuildContext context) {
    Size sz = MediaQuery.of(context).size;

    return SafeArea(

        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("登入"),
              backgroundColor: Colors.green.shade800,
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.green.shade50,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset('assets/images/house.png',height: sz.height * 0.4,width: double.infinity,),
                  const Text('歡迎登入租屋紅綠燈' , style:TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: '電子郵件',labelStyle: TextStyle(fontSize: 20)) ,
                    style: const TextStyle(fontSize: 20),
                    controller: accController

                  ),
                  const SizedBox(height: 20),
                  TextField(
                    textAlign: TextAlign.center,obscureText: true,
                    decoration: const InputDecoration(labelText: '密碼',labelStyle: TextStyle(fontSize: 20)) ,
                    style: const TextStyle(fontSize: 20),
                    controller: pwdController,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.green,
                      shadowColor: Colors.greenAccent,
                      child: GestureDetector(
                        onTap: (){
                          bool flag = false;

                          if(accController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("郵件必填"),
                              duration: Duration(seconds: 2),
                            ));
                            flag = false;
                          }
                          else {
                            if (!ValidatorHelper.isValidEmail(accController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("郵件格式錯誤"),
                                    duration: Duration(seconds: 2),
                                  ));

                              return;
                            }


                            flag = true;
                          }

                          if(pwdController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("密碼必填"),
                              duration: Duration(seconds: 2),
                            ));
                            flag = false;
                          }
                          else {
                            flag = true;
                          }

                          if(flag) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("登入中..."),
                                  duration: Duration(seconds: 1),
                                ));
                            // print('username=' + accController.text + '  pwd=' + pwdController.text);
                            String email = accController.text;
                            int atSign = email.indexOf('@');
                            String name = email.substring(0,atSign);

                            doLogin(name, pwdController.text).then((value) {
                              var today = DateTime.now();
                              String dateStr = today.year.toString() + '-' + today.month.toString().padLeft(2,'0') + '-' + today.day.toString().padLeft(2,'0') + ' ' +
                                  today.hour.toString().padLeft(2,'0') + ':' + today.minute.toString().padLeft(2,'0') + ':' + today.second.toString().padLeft(2,'0');

                              if(value.error.isNotEmpty){
                                DialogHelper.displayDialogOKCallBack(context, '錯誤', value.error, '確定');
                                return;
                              }

                              DataOperator.saveData('access', value.access);
                              DataOperator.saveData('refresh', value.refresh);
                              DataOperator.saveData('result', '1');
                              DataOperator.saveData('login', dateStr);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("登入成功"),
                                    duration: Duration(seconds: 2),
                                  ));

                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchScreen()));
                            });


                          }

                        },
                        child: const Center(
                          child:
                            Text('登入',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.white),),
                        ),

                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.orange,
                      shadowColor: Colors.orangeAccent,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  JoinScreen()));

                        },
                        child: const Center(
                          child:
                          Text('註冊',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.white),),
                        ),

                      ),
                    ),
                  )

                ],


              ),

            )
        )

    );

  }


  // Future<UserInfo> doLogin(String name , String pwd) async {
  //   final resp = await http.post(
  //     Uri.parse(loginUrl),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'username': name,'password':pwd
  //     }),
  //   );
  //
  //   if(resp.statusCode == 200){
  //     // print("****************");
  //     // print(UserInfo.fromJson(jsonDecode(resp.body)));
  //     return UserInfo.fromJson(jsonDecode(resp.body));
  //   }else{
  //     throw Exception('發生錯誤');
  //   }
  //
  // }

}
