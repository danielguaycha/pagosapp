/*
 * Permite hacer navegación en la aplicacion desde cualquier funcioón void u otra sin usar .of(context)
 * Actualmente se usa en la función de Login 
 */
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
  void goBack() {
    return navigatorKey.currentState.pop();
  }
}