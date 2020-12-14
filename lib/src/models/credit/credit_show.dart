// To parse this JSON data, do
//
//     final creditHistory = creditHistoryFromMap(jsonString);

import 'dart:convert';

import 'package:pagosapp/src/models/payments/payment_history.dart';
import 'package:pagosapp/src/utils/validators.dart';

class CreditShow {
    CreditShow({
        this.name,
        this.id,
        this.monto,
        this.utilidad,
        this.total,
        this.description,
        this.status,
        this.totalPagado,
        this.payments,
        this.pagados
    });

    String name;
    int id;
    double monto;
    double utilidad;
    double total;
    String description;
    int status;
    double totalPagado;
    int pagados;
    List<PaymentHistory> payments;

    factory CreditShow.fromJson(String str) => CreditShow.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CreditShow.fromMap(Map<String, dynamic> json) => CreditShow(
        name: json["name"],
        id: json["id"],
        monto: parseDouble(json["monto"]),
        utilidad: parseDouble(json["utilidad"]),
        total: parseDouble(json["total"]),
        description: json["description"],
        status: parseInt(json["status"]),
        totalPagado: parseDouble(json["total_pagado"]),
        pagados: parseInt(json['pagados']),
        payments: List<PaymentHistory>.from(json["payments"].map((x) => PaymentHistory.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
        "monto": monto,
        "utilidad": utilidad,
        "total": total,
        "description": description,
        "status": status,
        "total_pagado": totalPagado,
        "pagados": pagados,
        "payments": List<dynamic>.from(payments.map((x) => x.toMap())),
    };
}
