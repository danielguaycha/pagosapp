// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

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
        this.payments,
    });

    String name;
    int id;
    DateTime fInicio;
    DateTime fFin;
    double total;
    int status;
    double totalPagado;
    List<PaymentListChild> payments;

    factory PaymentList.fromJson(Map<String, dynamic> json) => PaymentList(
        name: json["name"],
        id: json["id"],
        fInicio: json["f_inicio"] == null ? null : DateTime.parse(json["f_inicio"]),
        fFin: json["f_fin"] == null ? null : DateTime.parse(json["f_fin"]),
        total: parseDouble(json["total"]),
        status: json["status"],
        totalPagado: parseDouble(json["total_pagado"]),
        payments: List<PaymentListChild>.from(json["payments"].map((x) => PaymentListChild.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "f_inicio": "${fInicio.year.toString().padLeft(4, '0')}-${fInicio.month.toString().padLeft(2, '0')}-${fInicio.day.toString().padLeft(2, '0')}",
        "f_fin": "${fFin.year.toString().padLeft(4, '0')}-${fFin.month.toString().padLeft(2, '0')}-${fFin.day.toString().padLeft(2, '0')}",
        "total": total,
        "status": status,
        "total_pagado": totalPagado,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
    };
}

class PaymentListChild {
    PaymentListChild({
        this.id,
        this.abono,
        this.status,
        this.mora,
        this.date,
        this.number,
        this.selected: false,
        this.diasMora: 0,
    });

    int id;
    double abono;
    int status;
    bool mora;
    DateTime date;
    int number;
    bool selected;
    int diasMora;

    factory PaymentListChild.fromJson(Map<String, dynamic> json) => PaymentListChild(
        id: json["id"],
        abono: parseDouble(json["abono"]),
        status: json["status"],
        mora: parseBool(json["mora"]),
        date: DateTime.parse(json["date"]),
        number: json["number"],
        diasMora: json["dias_mora"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "abono": abono,
        "status": status,
        "mora": mora,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "number": number,
        "dias_mora" : diasMora,
    };
}