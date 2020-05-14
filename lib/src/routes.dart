import 'package:flutter/material.dart';
import 'package:pagosapp/src/pages/client/new_client_page.dart';
import 'package:pagosapp/src/pages/credit/new_credit_page.dart';
import 'package:pagosapp/src/pages/home_page.dart';
import 'package:pagosapp/src/pages/login_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {

  return <String, WidgetBuilder>{
    'login': (BuildContext context) => LoginPage(),
    'home': (BuildContext context) => HomePage(),
    'client_add': (BuildContext context) => NewClientPage(),
    'credit_add': (BuildContext context) => NewCreditPage(),
  };
}