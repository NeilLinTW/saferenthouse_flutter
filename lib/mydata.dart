import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDataScreen extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("註冊"),
            backgroundColor: Colors.green.shade800,
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.green.shade50,
        )

    );

  }




}