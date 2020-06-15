
import 'package:pagosapp/env.dart';

const debug = false;
const buildVersion = 1.0; // incrementar segun la actualización en el server

const urlProduction = 'app.detzerg.company';
const urlDebug = server;

const appName = "PayApp";
const urlApi = "http://${(debug == true ? urlDebug : urlProduction )}/api";

const Map<String, String> cobros = {
    'DIARIO': 'Diario',
    'SEMANAL': 'Semanal',
    'QUINCENAL': 'Quincenal',
    'MENSUAL': 'Mensual',
};

const Map<String, String> plazos = {
    'SEMANAL': '6 cuotas',
    'QUINCENAL': '15 cuotas',
    'MENSUAL': '30 cuotas',
    'MES_Y_MEDIO': '45 cuotas',
    'DOS_MESES': '60 cuotas'
};

const Map<String, String> categorias = {
    'COMIDA'          : 'Comida',
    'COMBUSTIBLE'     : 'Combustible',
    'PAGO DE SERVICIO': 'Pago de servicio',
    'SERVICIO BASICO' : 'Servicio basico',
    'OTROS PAGOS'     : 'Otros pagos',
    'OTROS'           : 'Otros',
};

const List<int> utilidad = [5, 10, 20, 40];
//? Agregar aqui solo variables staticas que no cambian