// To parse this JSON data, do
//
//     final DataPay = DataPayFromJson(jsonString);

import 'dart:convert';

import 'package:pagosapp/src/utils/validators.dart';

DataPay dataPayFromJson(String str) => DataPay.fromJson(json.decode(str));

String dataPayToJson(DataPay data) => json.encode(data.toJson());

class DataPay {
    DataPay({
        this.id,
        this.number,
        this.total,
        this.abono,
        this.creditId,
        this.userId,
        this.status,
        this.date,
        this.datePayment,
        this.description,
        this.mora,
        this.diasMora,
    });

    int id;
    int number;
    String total;
    double abono;
    int creditId;
    int userId;
    int status;
    DateTime date;
    DateTime datePayment;
    String description;
    bool mora;
    int diasMora;

    factory DataPay.fromJson(Map<String, dynamic> json) => DataPay(
        id: json["id"],
        number: json["number"],
        total: json["total"].toString(),
        abono: parseDouble(json["abono"]),
        creditId: json["credit_id"],
        userId: json["user_id"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
        datePayment: DateTime.parse(json["date_payment"]),
        description: json["description"],
        mora: parseBool(json["mora"]),
        diasMora: json["dias_mora"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "total": total,
        "abono": abono,
        "credit_id": creditId,
        "user_id": userId,
        "status": status,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "date_payment": datePayment.toIso8601String(),
        "description": description,
        "mora": mora,
        "dias_mora": diasMora,
    };
}
