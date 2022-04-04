import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_rent_house/rate.dart';
import '../join.dart';
import '../login.dart';
import 'DataOperator.dart';
import 'dart:io';

class MenuLogin extends StatelessWidget {
  // const MenuLogin({Key? key}) : super(key: key);
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromRGBO(46, 125, 50, 1),
        child: ListView(
          children:  <Widget>
          [
            const SizedBox(height: 10,),
            const Text('租房紅綠燈' ,textAlign: TextAlign.center ,style: TextStyle(color: Colors.white , fontSize: 30)),
            // const SizedBox(height: 20,),
            // buildMenuItems(text: '我的資料',icon: Icons.speaker_notes_outlined),
            const SizedBox(height: 20,),
            buildMenuItems(text: '我要評分',icon: Icons.star , onClicked: () => rate(context)),
            const Divider(color: Colors.white,),
            const SizedBox(height: 20,),
            buildMenuItems(text: '結束程式',icon: Icons.exit_to_app , onClicked: () => exitApp(context)),
            const SizedBox(height: 20,),
          ],


        ),

      ),
    );
  }


  void exitApp(BuildContext context){
    Navigator.of(context).pop();

    if(Platform.isAndroid){
      SystemNavigator.pop();
    }else{
      exit(0);
    }
  }

  void rate(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  RateScreen()));

  }

  Widget buildMenuItems({ required String text,  required IconData icon, VoidCallback? onClicked,}){
    const color = Colors.white;

    return ListTile(
        leading: Icon(icon,color: color,),
        title: Text(text , style: const TextStyle(color: color , fontSize: 20),),
        hoverColor: Colors.white70,
        onTap: onClicked,
    );
  }


  List<Widget> buildDrawerList(BuildContext context) {
    List<Widget> children = [];
    List<Widget> dataList = [];

    dataList.add(const DrawerHeader(decoration: BoxDecoration(color:Colors.green), child: Text('租屋紅綠燈',style: TextStyle(color:Colors.white , fontSize: 24),)),);

    dataList.add(
      ListTile(leading: const Icon(Icons.add_reaction_outlined),title: const Text('我要刊登',style: TextStyle(fontSize: 18),),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    );

    String value = DataOperator.readData('result');
      if(value == '1'){
        dataList.add(
          ListTile(leading: const Icon(Icons.speaker_notes_outlined),title: const Text('我的資料',style: TextStyle(fontSize: 18),),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        );
      }


    dataList.add(const Divider(),);

    dataList.add(
      ListTile(
        leading: const Icon(Icons.person_add_alt),title: const Text('註冊帳號',style: TextStyle(fontSize: 18)),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  JoinScreen()));
          // Navigator.pop(context);
        },
      ),
    );

    dataList.add(
      ListTile(
        leading: const Icon(Icons.login),title: const Text('登入',style: TextStyle(fontSize: 18)),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
          // Navigator.pop(context);

        },
      ),
    );

    children.addAll(dataList);

    return children;
  }

}