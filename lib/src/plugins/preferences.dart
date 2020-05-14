
/*
* Manejo de las preferencias de usuario
*/ 
import 'package:shared_preferences/shared_preferences.dart';

class LocalPrefs {
  static final LocalPrefs _instance = new LocalPrefs._internal();

  factory LocalPrefs () {
    return _instance;
  }

  LocalPrefs._internal();
  SharedPreferences  _prefs;

  initPrefs() async{
    
    _prefs = await SharedPreferences.getInstance();
  }

  // token
  get token {
    return _prefs.getString("token") ?? null;
  }

  set token (String token) {
    _prefs.setString("token", token);
  }
}