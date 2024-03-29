/*
 * Solo para manejar errores de la app
 * Ejemplo: Renderear errores en la API
 */

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/config.dart';

void ddHttp(String msg, {err}) {
  if(!debug) return;
  if(err == null) {
    print("::Debug::> $msg");
  } else {
    var er = processError(err);
    print("::$msg::> ${er['message']}");
  }
}

// Monstrar una vista con el error
Widget renderError(error, Function callback) {
  print(error);
  if (error is DioError) {
    DioError e = error;

    if (debug) {
      debugPrint(e.message);
    }

    if (e.response != null && e.response.data != null) {
      final msg = e.response.data['error'];
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.exclamation),
          SizedBox(height: 20),
          Text(msg == null
              ? 'Error desconocido, contacte con el administrador'
              : msg)
        ],
      ));
    } else {
      if (e.type == DioErrorType.DEFAULT) {
        return _defaultErrorContainer(
            callback: callback,
            msg: "No se pudo comunicar con el servidor",
            icon: FontAwesomeIcons.wifi);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        return _defaultErrorContainer(
            callback: callback,
            msg: "El servidor no responde, contacte con soporte",
            icon: FontAwesomeIcons.question);
      }
      return Center(
          child:
              Text("Error desconocido con el servidor, contacte con soporte!"));
    }
  } else {
    if (debug) {
      debugPrint(error.toString());
    }
    return Center(child: Text("Error desconocido, contacte con soporte!"));
  }
}

// Procesar Errores
Map<String, dynamic> processError(error) {
  if (error is DioError) {
    DioError e = error;
    if (debug) {
      print("===================");
      print("$e");
      print("===================");
    }
    if (e.response != null && e.response.data != null) {
      String msg = '';
      if (e.response.data['message'] != null &&
          e.response.data['errors'] == null)
        msg = e.response.data['message'];
      else if (e.response.data['error'] != null)
        msg = e.response.data['error'];
      else if (e.response.data['errors'] != null) {
        List<dynamic> errs = e.response.data['errors'];
        errs.forEach((f) {
          if (f.length > 0) {
            String err = (f[0]).toString();
            msg += err + ", ";
          }
        });
        msg += "--";
        msg = msg.replaceAll(", --", "");
      } else {
        msg = 'Error desconocido en la respuesta, contacte a soporte #1';
      }
      return {'ok': false, 'message': msg};
    } else {
      if (e.type == DioErrorType.DEFAULT) {
        print("ERROR: $error ");
        return {
          'ok': false,
          'message': "No se pudo comunicar con el servidor #2"
        };
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        return {
          'ok': false,
          'message': "El servidor no responde, contacte con soporte #3"
        };
      }
      return {
        'ok': false,
        'message': "Error desconocido con el servidor, contacte con soporte! #4"
      };
    }
  }
  return {'ok': false, 'message': 'Error desconocido, contacte con soporte #5'};
}

Widget renderNotFoundData(String msg) {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(FontAwesomeIcons.searchMinus, size: 60, color: Colors.blueGrey),
      SizedBox(height: 15),
      Text(msg,
          style:
              TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
    ],
  ));
}

Widget _defaultErrorContainer(
    {Function callback, String msg, IconData icon: FontAwesomeIcons.dizzy}) {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(icon, size: 60, color: Colors.blueGrey),
      SizedBox(height: 15),
      Text(msg,
          style:
              TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500)),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          "Revise su conexión a internet, sus datos móviles, su intensidad de señal",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black38, fontSize: 14),
        ),
      ),
      SizedBox(height: 10),
      (callback != null)
          ? MaterialButton(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: Border.all(width: 2.0, color: Colors.blueGrey[600]),
              textColor: Colors.blueGrey[600],
              elevation: 2,
              child: Text("Reintentar"),
              onPressed: () {
                callback();
              },
            )
          : Center()
    ],
  ));
}