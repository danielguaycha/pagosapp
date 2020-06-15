import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast(String msg, {String type: 'default' }) {
  Color color;
  if(type == "default"){
    color = Colors.black87;
  }
  if(type == 'err') {
    color = Colors.red;
  }
  if(type == 'ok') {
    color = Colors.green;
  }

  Fluttertoast.showToast(
      msg: "$msg",
      toastLength: type == 'ok'  ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 14.0);
}
