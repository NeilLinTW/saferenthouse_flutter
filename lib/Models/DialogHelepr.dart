import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {


  static Future<bool?> displayDialogOKCallBack(
      BuildContext context, String title, String message , String buttonTitle) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title,),
          content:  Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(buttonTitle),
              onPressed: () {
                Navigator.of(context).pop(true);

              },
            )
          ],
        );
      },
    );
  }
}