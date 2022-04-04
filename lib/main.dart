import 'package:flutter/material.dart';
import 'package:safe_rent_house/login.dart';
import 'package:safe_rent_house/search.dart';
import 'Models/DialogHelepr.dart';
import 'Models/MenuLogin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Models/DataOperator.dart';
import 'package:url_launcher/link.dart';
import 'dart:async';

StreamController streamClr = StreamController<int>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataOperator.init();
  DataOperator.clear();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  // VoidCallback dialog;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      initialRoute: '/',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: MyHomePage('租屋紅綠燈' , streamClr.stream),
      // home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // const MyHomePage({Key? key, required this.title}) : super(key: key);
  MyHomePage(this.title , this.streamA);
  final String title;
  final Stream streamA;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isRow = false;
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start;
  MainAxisSize mainAxisSize = MainAxisSize.min;
  String number = '';

  void setLayout(int index) => setState(() => isRow = index == 0);


  void setNumber(String idx){
    setState(() {
      number = idx;
    });
  }

  @override
  void initState() {
    super.initState();

    // widget.streamA.listen((index) {
    //   setNumber(index);
    //
    // });
  }


  @override
  Widget build(BuildContext context) {

    //Drawer(
    //         child: ListView(
    //           padding: EdgeInsets.zero,
    //           children: MenuLogin().buildDrawerList(context)
    //         ),
    //
    //       ),

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      drawer: MenuLogin(),
      body: Container(
        width: double.infinity,
        height: double.maxFinite,
        decoration:  BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/road.jpg') , fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop)
          )
        ),
          child: buildContent()
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green.shade800,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type:BottomNavigationBarType.fixed ,
        onTap: (idx) async {


          switch(idx){
            case 0:
              String access = '';
              DataOperator.init();

              access = DataOperator.readData('access');
                if(access.isEmpty) {
                  // print('access isEmpty');

                  DialogHelper.displayDialogOKCallBack(context, '訊息', '登入後看內幕，即將前往登入頁','好，我期待很久了').then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()));
                  });

                  // showAlertDialog(context, '登入後看內幕，即將前往登入頁', "訊息" , "好，我期待很久了");
                } else {
                  // print('access not Empty');
                  // print(access);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  SearchScreen()));
                }

              break;
            case 1:
              // Navigator.push(context, MaterialPageRoute(builder: (context) =>  MessageScreen()));
              // const url = 'https://forms.gle/j4ZxU9baSjsbYhM5A';
              const url = 'https://docs.google.com/forms/d/e/1FAIpQLSf-_cg0koRp0ueG3xQcWQyxOBzp_DKNlPVDPZvrFyNEAuNkyg/viewform?usp=sf_link';
              if (await canLaunch(url)) {
                await launch(
                    url ,
                    forceSafariVC: true ,
                    forceWebView: true,
                    enableJavaScript: true
                );

              }
              else{
                throw '無法前往 google forms';
              }

              break;
          }

        },
        items:const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.saved_search),label: '我要查詢'),
          BottomNavigationBarItem(icon: Icon(Icons.message),label: '聯絡我們')
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );


  }

  Widget buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget> [
        Expanded(flex: 5,child:
          Text('租屋紅綠燈是租屋族專屬的APP\n租屋遇到權益受害，\n不知道怎麼辦，\n例如：房東帶外人進入、\n房東裝監控偷看隱私，\n司法訴訟時程快則半年，\n慢則拖過一年又一年，\n租房紅綠燈歡迎您刊登，\n提供相關證據待我們審核，\n目前免費刊登',
            textAlign: TextAlign.center,style: TextStyle(fontSize: 20,height: 2.2),
          ),
        ),

      ],

    );
  }


  // showAlertDialog(
  //     BuildContext context, String message, String heading, String buttonAcceptTitle) {
  //
  //   AlertDialog alert = AlertDialog(
  //     title: Text(heading),
  //     content: Text(message),
  //     actions: [
  //       TextButton(
  //         child: Text(buttonAcceptTitle),
  //         onPressed: () {
  //           Navigator.pop(context, 'Cancel');
  //
  //
  //         },
  //       ),
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }



}
