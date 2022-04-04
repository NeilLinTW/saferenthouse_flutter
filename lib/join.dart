import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:safe_rent_house/login.dart';
import 'package:safe_rent_house/search.dart';
import 'Models/DataOperator.dart';
import 'Models/DialogHelepr.dart';
import 'Models/LoginHelper.dart';
import 'Models/UserInfo.dart';
import 'Models/ValidatorHelper.dart';


class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JoinScreen();

}


class _JoinScreen extends State<JoinScreen> {
  // JoinScreen({Key? key}) : super(key: key);
  final mailController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size sz = MediaQuery.of(context).size;
    String msg = '';

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("註冊"),
            backgroundColor: Colors.green.shade800,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.green.shade50,
        body: SingleChildScrollView (
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              children:  <Widget>[
                const SizedBox(height: 5),
                Image.asset('assets/images/checkhouse.png',height: sz.height * 0.3,width: double.infinity,),
                const Text('歡迎註冊租屋紅綠燈' , style:TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: '電子郵件',labelStyle: TextStyle(fontSize: 20)) ,
                  style: TextStyle(fontSize: 20),
                  controller: mailController,
                ),
                const SizedBox(height: 20),
                TextField(
                  textAlign: TextAlign.center,obscureText: true,
                  decoration: const InputDecoration(labelText: '密碼',labelStyle: TextStyle(fontSize: 20)) ,
                  style: TextStyle(fontSize: 20),
                  controller: pwdController,
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepOrange,
                    shadowColor: Colors.deepOrangeAccent,
                    child: GestureDetector(
                      onTap: () {
                          if (!ValidatorHelper.isValidEmail(mailController
                              .text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("郵件格式錯誤"),
                                  duration: Duration(seconds: 2),
                                ));

                            return;
                          }

                          if (pwdController.text.length < 5) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("密碼長度小於5"),
                                  duration: Duration(seconds: 2),
                                ));

                            return;
                          }

                          // DataOperator.readData('access').then((value){
                          //   // print(value);
                          // });

                          doRegister(context, pwdController.text, mailController
                              .text).then((value) {
                            // print(value);
                            // print('CLICK REGISTER');

                            if (value.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('發生錯誤'),
                                    duration: Duration(seconds: 2),
                                  ));

                              return;
                            } else {
                              // print('register');
                              // print(mailController.text);
                              // print(pwdController.text);

                              Future.delayed(Duration(seconds: 1), (){
                                doLogin(value, pwdController.text).then((value) {
                                  DataOperator.saveData('access', value.access);
                                  DataOperator.saveData('refresh', value.refresh);
                                  DataOperator.saveData('result', '1');

                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchScreen()));
                                });


                              });

                            }
                          });




                      },
                      child: const Center(
                        child: Text('註冊',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.white),),

                      ),

                    ),
                  ),
                ),

              ]

          ),
        ),


        ),



    );
  }

  Future<String> doRegister(BuildContext context , String pwd , String email) async {
    const String registerUrl = 'https://rentapi.11235.tw/auth/register/';
    int atSign = email.indexOf('@');
    String name = email.substring(0,atSign);

    // print('name=' + name + ' , pwd=' + pwd + ' ,mail=' + email);

    final resp = await http.post(
      Uri.parse(registerUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'username': name,
        'email': email,
        'password':pwd
      }),
    );

    String msg = '';
    if(resp.statusCode == 201){
      Map<String, dynamic> obj = json.decode(utf8.decode(resp.bodyBytes));
      RegisterInfo info = RegisterInfo.fromJson(obj['User']);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(obj['Message']),
        duration: const Duration(seconds: 2),
      ));

      DataOperator.saveData('username',name);
      DataOperator.saveData('mail',info.email ?? '');
      DataOperator.saveData('yourdadsnumber',pwd);

      return info.username ?? '';
    }else{
      Map<String, dynamic> err = json.decode(utf8.decode(resp.bodyBytes));
      msg = err['error'][0];

      DialogHelper.displayDialogOKCallBack(context, '訊息', '郵件已存在','前往登入頁').then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
      });
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(msg),
      //   duration: const Duration(seconds: 2),
      // ));

      // throw Exception('發生錯誤' + err['error'][0]);
      return '';
    }
    // final info = new UserInfo(access: '123',refresh: 'fff');
    //
    // return  info;

  }

  
}