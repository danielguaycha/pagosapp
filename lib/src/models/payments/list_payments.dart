// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DataPaymentClient dataPaymentClientFromJson(String str) => DataPaymentClient.fromJson(json.decode(str));

String dataPaymentClientToJson(DataPaymentClient data) => json.encode(data.toJson());

class DataPaymentClient {
    DataPaymentClient({
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
    String total;
    int status;
    double totalPagado;
    List<Payment> payments;

    factory DataPaymentClient.fromJson(Map<String, dynamic> json) => DataPaymentClient(
        name: json["name"],
        id: json["id"],
        fInicio: DateTime.parse(json["f_inicio"]),
        fFin: DateTime.parse(json["f_fin"]),
        total: json["total"],
        status: json["status"],
        totalPagado: json["total_pagado"],
        payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
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

class Payment {
    Payment({
        this.id,
        this.abono,
        this.status,
        this.mora,
        this.date,
        this.number,
    });

    int id;
    String abono;
    int status;
    bool mora;
    DateTime date;
    int number;

    factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        abono: json["abono"],
        status: json["status"],
        mora: json["mora"],
        date: DateTime.parse(json["date"]),
        number: json["number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "abono": abono,
        "status": status,
        "mora": mora,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "number": number,
    };
}


class PaymentRequest {
    PaymentRequest({
        this.id,
        this.total
    });

    int id;
    double total;

    factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        id: json["pay"],
        total: json["total"]
    );

    Map<String, dynamic> toJson() => {
        "pay": id,
        "total": total
    };
}
