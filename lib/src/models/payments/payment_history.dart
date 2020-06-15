
import 'dart:convert';

class PaymentHistory {
    static const MORA = -1;
    static const PENDIENTE = 1;
    static const COBRADO = 2;
    PaymentHistory({
        this.id,
        this.total,
        this.status,
        this.mora,
        this.date,
        this.number,
    });

    int id;
    double total;
    int status;
    int mora;
    DateTime date;
    int number;

    factory PaymentHistory.fromJson(String str) => PaymentHistory.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PaymentHistory.fromMap(Map<String, dynamic> json) => PaymentHistory(
        id: json["id"],
        total: json["total"].toDouble(),
        status: json["status"],
        number: json["number"],
        mora: json["mora"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "total": total,
        "status": status,
        "number": number,
        "mora": mora,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };

    getStatus(){
      if(this.status == 2) {
        return 'COBRADO';
      }
      if(this.status == -1) {
        return 'MORA';
      }

      return 'PENDIENTE';
    }
}
