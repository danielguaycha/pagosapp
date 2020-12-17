import 'package:flutter/material.dart';
import 'package:pagosapp/src/pages/client/new_client_page.dart';
import 'package:pagosapp/src/pages/client/list_client_page.dart';
import 'package:pagosapp/src/pages/credit/add_credit_page.dart';
import 'package:pagosapp/src/pages/payments/list_expense_page.dart';
import 'package:pagosapp/src/pages/recaudation/recaudar_list_payments_page.dart';
/* import 'package:pagosapp/src/pages/credit/new_credit_page.dart'; */
import 'package:pagosapp/src/pages/home_page.dart';
import 'package:pagosapp/src/pages/login_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {

  return <String, WidgetBuilder>{
    'login': (BuildContext context) => LoginPage(),
    'home': (BuildContext context) => HomePage(),
    'client_add': (BuildContext context) => NewClientPage(),
    'client_list': (BuildContext context) => ListClientPage(returning: false),
    'credit_add': (BuildContext context) => AddCreditPage(),
    'payment': (BuildContext context) => RacaudarListPayment(),
    'expense': (BuildContext context) => ListExpensePage(),
  };
}