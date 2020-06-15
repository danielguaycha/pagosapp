import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:pagosapp/src/config.dart';
import 'package:pagosapp/src/pages/home_page.dart';
import 'package:pagosapp/src/pages/login_page.dart';
import 'package:pagosapp/src/plugins/navigator.dart';
import 'package:pagosapp/src/plugins/preferences.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
GetIt locator = GetIt.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPrefs().initPrefs();
  locator.registerLazySingleton(() => NavigationService());  
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _prefs = new LocalPrefs();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Style.primary[800]));
    return AlertProvider(  
      child: MaterialApp(
        navigatorKey: locator<NavigationService>().navigatorKey,
        title: appName,
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          const Locale('en'), // English
          const Locale('es'), // Spanish
          // ... other locales the app supports
        ],
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(        
          primaryColor: Style.primary,        
          accentColor: Style.secondary,
          cursorColor: Style.secondary[900],
          primarySwatch: Style.primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
         home: (_prefs.token != null) ?
            HomePage() :
            LoginPage(),
          // initialRoute: 'login',
          routes: getAppRoutes(),
      ),
      config: new AlertConfig(
        ok: "SI", 
        cancel: "CANCELAR", useIosStyle: false),      
    );
  }
}