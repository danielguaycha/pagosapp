// To parse this JSON data, do
//
//     final paymentRow = paymentRowFromMap(jsonString);

import 'dart:convert';

class PaymentRow {

    static const MORA = -1;
    static const PENDIENTE = 1;
    static const COBRADO = 2;

    PaymentRow({
        this.cobro,
        this.id,
        this.creditId,
        this.total,
        this.status,
        this.mora,
        this.number,
        this.description,
        this.clientId,
        this.clientName,
        this.addressA,
        this.cityA,
    });

    String cobro;
    int id;
    int creditId;
    double total;
    int status;
    int mora;
    int number;
    String description;
    int clientId;
    String clientName;
    String addressA;
    String cityA;

    factory PaymentRow.fromJson(String str) => PaymentRow.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PaymentRow.fromMap(Map<String, dynamic> json) => PaymentRow(
        cobro: json["cobro"],
        id: json["id"],
        creditId: json["credit_id"],
        total: json["total"].toDouble(),
        status: json["status"],
        mora: json["mora"],
        number: json["number"],
        description: json["description"],
        clientId: json["client_id"],
        clientName: json["client_name"],
        addressA: json["address_a"],
        cityA: json["city_a"],
    );

    Map<String, dynamic> toMap() => {
        "cobro": cobro,
        "id": id,
        "credit_id": creditId,
        "total": total,
        "status": status,
        "mora": mora,
        "number": number,
        "description": description,
        "client_id": clientId,
        "client_name": clientName,
        "address_a": addressA,
        "city_a": cityA,
    };
}
