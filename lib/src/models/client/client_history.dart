// To parse this JSON data, do
//
//     final clientHistory = clientHistoryFromMap(jsonString);

import 'dart:convert';

import 'package:pagosapp/src/utils/validators.dart';
import 'package:flutter/material.dart';

class ClientHistory {
  int id;
  String name;
  int rank;
  String cityA;
  String addressA;
  dynamic cityB;
  dynamic addressB;
  int status;
  int credit;
  DateTime fInicio;
  DateTime fFin;
  double total;
  double paid;
  String cobro;

  ClientHistory({
    this.id,
    this.name,
    this.rank,
    this.cityA,
    this.addressA,
    this.cityB,
    this.addressB,
    this.status,
    this.credit,
    this.fInicio,
    this.fFin,
    this.total,
    this.paid,
    this.cobro
  });
  
  factory ClientHistory.fromJson(String str) =>
      ClientHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClientHistory.fromMap(Map<String, dynamic> json) => ClientHistory(
        id: json["id"],
        name: json["name"],
        rank: parseInt(json["rank"]),
        cityA: json["city_a"],
        addressA: json["address_a"],
        cityB: json["city_b"],
        addressB: json["address_b"],
        status: parseInt(json["status"]),
        credit: parseInt(json["credit"]),
        cobro: json['cobro'],
        fInicio: json["f_inicio"] != null ? DateTime.parse(json["f_inicio"]) : null,
        fFin: json["f_fin"] != null ? DateTime.parse(json["f_fin"]) : null,
        total: parseDouble(json["total"]),
        paid: parseDouble(json["paid"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "rank": rank,
        "city_a": cityA,
        "address_a": addressA,
        "city_b": cityB,
        "address_b": addressB,
        "status": status,
        "credit": credit,
        "f_inicio":
            "${fInicio.year.toString().padLeft(4, '0')}-${fInicio.month.toString().padLeft(2, '0')}-${fInicio.day.toString().padLeft(2, '0')}",
        "f_fin":
            "${fFin.year.toString().padLeft(4, '0')}-${fFin.month.toString().padLeft(2, '0')}-${fFin.day.toString().padLeft(2, '0')}",
        "total": total,
        'paid': paid,
        'cobro': cobro
      };

  getColor() {
      if(rank <= 100 && rank >= 90) {
        return Colors.green[800];
      }

      if(rank >= 50 && rank < 90 ) {
        return Colors.orange;
      }

      if(rank < 50) {
        return Colors.red;
      }
    }
}
