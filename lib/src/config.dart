
import 'package:pagosapp/env.dart';

const debug = true;
const buildVersion = 1.0; // incrementar segun la actualización en el server

const urlProduction = 'app.detzerg.company';
const urlDebug = server;

const appName = "PayApp";
const urlApi = "http://${(debug == true ? urlDebug : urlProduction )}/api";

//? Agregar aqui solo variables staticas que no cambian