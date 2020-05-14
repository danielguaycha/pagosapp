/*
 *  Aqui solo poner logica de widgets 
*/

import 'package:flutter/material.dart';

Widget miniLoader() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)),
            height: 25,
            width: 25)
      ],
    ),
  );
}