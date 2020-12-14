import 'package:pagosapp/src/utils/validators.dart';

class PaymentListChild {
  static const NO_PAID = -2;
  static const MORA = -1;
  static const PENDIENTE = 1;
  static const COBRADO = 2;
  static const PARTIAL_PAID = 3;

  PaymentListChild({
    this.id,
    this.abono,
    this.pending,
    this.status,
    this.mora,
    this.date,
    this.datePayment,
    this.selected: false,
    this.description,
    this.total
  });

  int id;
  double abono;
  double total;
  double pending;
  int status;
  bool mora;
  DateTime date;
  DateTime datePayment;
  bool selected;
  String description;

  factory PaymentListChild.fromJson(Map<String, dynamic> json) => PaymentListChild(
    id: json["id"],
    abono: parseDouble(json["abono"]),
    total: parseDouble(json["total"]),
    pending: parseDouble(json["pending"]),
    status: parseInt(json["status"]),
    mora: parseBool(json["mora"]),
    date: DateTime.parse(json["date"]),
    datePayment: json["date_payment"] == null ? null : DateTime.parse(json["date_payment"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "abono": abono,
    "total": total,
    "pending": pending,
    "status": status,
    "mora": mora,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "date_payment": datePayment.toIso8601String(),
    "description" : description,
  };

  @override
  String toString() {
    return 'PaymentListChild{id: $id, total: $total, abono: $abono, pendiente:$pending status: $status, date: $date, description: $description}';
  }

  getDescription() {
    switch (this.status) {
      case COBRADO:
          return dateForHumans2(this.datePayment);
      case PARTIAL_PAID:
        return "Incompleto";
      case NO_PAID:
        return "No pagó";
      default: return "";
    }
  }


}