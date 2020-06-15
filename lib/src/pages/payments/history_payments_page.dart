import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/credit/credit_history.dart';
import 'package:pagosapp/src/pages/payments/widgets/history_payments_body.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';

class ListPaymentsPage extends StatefulWidget {
  final int id;

  ListPaymentsPage({Key key, @required this.id}) : super(key: key);

  @override
  _ListPaymentsPageState createState() => _ListPaymentsPageState();
}

// Codigo extra
Icon iconoPanel = new Icon(Icons.arrow_upward);
final _scaffoldKey = GlobalKey<ScaffoldState>();
// Fin codigo extra

class _ListPaymentsPageState extends State<ListPaymentsPage> {
  // ProgressLoader _loader;
  // TextEditingController _textEditingController = new TextEditingController();
  String reason = "";

  @override
  Widget build(BuildContext context) {
    // _loader = new ProgressLoader(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text("Historial de Cobros"),),
        body: FutureBuilder(          
          future: PaymentProvider().listPayments(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return renderError(snapshot.error, () {});
            }
            if (!snapshot.hasData) return loader(text: "Cargando créditos...");

            var results = snapshot.data.data;

            if (results != null && results.length <= 0) {
              return renderNotFoundData("No tienes rutas asignadas aún");
            }

            CreditHistory c = CreditHistory.fromJson(json.encode((results)));

            return bodyPayments(c);
          },
        ));
  }


}
