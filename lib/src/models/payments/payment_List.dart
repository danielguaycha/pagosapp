// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:pagosapp/src/models/payments/payment_list_child.dart';
import 'package:pagosapp/src/utils/validators.dart';

PaymentList dataPaymentClientFromJson(String str) => PaymentList.fromJson(json.decode(str));

String dataPaymentClientToJson(PaymentList data) => json.encode(data.toJson());

class PaymentList {
    static const MORA = -1;
    static const PENDIENTE = 1;
    static const COBRADO = 2;

    PaymentList({
        this.name,
        this.id,
        this.fInicio,
        this.fFin,
        this.total,
        this.status,
        this.totalPagado,
        this.monto,
        this.payments,
    });

    String name;
    int id;
    DateTime fInicio;
    DateTime fFin;
    double total;
    double monto;
    int status;
    double totalPagado;
    List<PaymentListChild> payments;

    factory PaymentList.fromJson(Map<String, dynamic> json) => PaymentList(
        name: json["name"],
        id: json["id"],
        fInicio: json["f_inicio"] == null ? null : DateTime.parse(json["f_inicio"]),
        fFin: json["f_fin"] == null ? null : DateTime.parse(json["f_fin"]),
        total: parseDouble(json["total"]),
        monto: parseDouble(json["monto"]),
        status: parseInt(json["status"]),
        totalPagado: parseDouble(json["total_pagado"]),
        payments: List<PaymentListChild>.from(json["payments"].map((x) => PaymentListChild.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "f_inicio": "${fInicio.year.toString().padLeft(4, '0')}-${fInicio.month.toString().padLeft(2, '0')}-${fInicio.day.toString().padLeft(2, '0')}",
        "f_fin": "${fFin.year.toString().padLeft(4, '0')}-${fFin.month.toString().padLeft(2, '0')}-${fFin.day.toString().padLeft(2, '0')}",
        "total": total,
        "monto": monto,
        "status": status,
        "total_pagado": totalPagado,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
    };
}