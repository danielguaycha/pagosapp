// To parse this JSON data, do
//
//     final paymentStore = paymentStoreFromMap(jsonString);

import 'dart:convert';

class PaymentStore {
    PaymentStore({
        this.pays,
    });

    List<Pay> pays;

    factory PaymentStore.fromJson(String str) => PaymentStore.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PaymentStore.fromMap(Map<String, dynamic> json) => PaymentStore(
        pays: List<Pay>.from(json["pays"].map((x) => Pay.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "pays": List<dynamic>.from(pays.map((x) => x.toMap())),
    };
}

class Pay {
    Pay({
        this.pay,
        this.total,
    });

    int pay;
    double total;

    factory Pay.fromJson(String str) => Pay.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Pay.fromMap(Map<String, dynamic> json) => Pay(
        pay: json["pay"],
        total: json["total"],
    );

    Map<String, dynamic> toMap() => {
        "pay": pay,
        "total": total,
    };
}
