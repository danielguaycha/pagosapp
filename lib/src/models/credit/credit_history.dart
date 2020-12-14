// To parse this JSON data, do
//
//     final creditHistory = creditHistoryFromMap(jsonString);

import 'dart:convert';

import 'package:pagosapp/src/utils/validators.dart';

class CreditHistory {
  static const STATUS_ANULADO = 0;
  static const STATUS_ACTIVO = 1;
  static const STATUS_FINALIZADO = 2;

  CreditHistory({
    this.fInicio,
    this.fFin,
    this.mora,
    this.total,
    this.plazo,
    this.cobro,
    this.status,
  });

  DateTime fInicio;
  DateTime fFin;
  int mora;
  double total;
  String plazo;
  String cobro;
  int status;

  factory CreditHistory.fromJson(String str) => CreditHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreditHistory.fromMap(Map<String, dynamic> json) => CreditHistory(
    fInicio: DateTime.parse(json["f_inicio"]),
    fFin: DateTime.parse(json["f_fin"]),
    mora: parseInt(json["mora"]),
    total: parseDouble(json["total"]),
    plazo: json["plazo"],
    cobro: json["cobro"],
    status: parseInt(json["status"]),
  );

  Map<String, dynamic> toMap() => {
    "f_inicio": "${fInicio.year.toString().padLeft(4, '0')}-${fInicio.month.toString().padLeft(2, '0')}-${fInicio.day.toString().padLeft(2, '0')}",
    "f_fin": "${fFin.year.toString().padLeft(4, '0')}-${fFin.month.toString().padLeft(2, '0')}-${fFin.day.toString().padLeft(2, '0')}",
    "mora": mora,
    "total": total,
    "plazo": plazo,
    "cobro": cobro,
    "status": status,
  };
}
