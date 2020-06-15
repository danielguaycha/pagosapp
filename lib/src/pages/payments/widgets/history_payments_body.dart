import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/credit/credit_history.dart';
import 'package:pagosapp/src/models/payments/payment_history.dart';
import 'package:pagosapp/src/pages/payments/widgets/history_payments_slideable.dart';
import 'package:pagosapp/src/utils/validators.dart';

Widget bodyPayments(CreditHistory c) {
  return Column(
    children: <Widget>[
      _labelClient(contenido: "${c.name}".toUpperCase()),
      Row(
        children: <Widget>[
          Expanded(
            child: _mediumCircle(value: money(c.monto), etiqueta: "Prestamo"),
          ),
          Expanded(
            child: _bigCircle(value: money(c.total), etiqueta: "Total a pagar"),
          ),
          Expanded(
            child: _mediumCircle(value: "${c.utilidad} %", etiqueta: "Interés"),
          ),
        ],
      ),
      Center(
        child: _labelDetail(description: "${c.description}"),
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: _labelInformation(
                contenido: money(c.totalPagado), etiqueta: "Total pagado"),
          ),
          _line(),
          Expanded(
            child: _labelInformation(
                contenido: "${c.pagados} / ${c.payments.length}",
                etiqueta: "Pagos"),
          ),
        ],
      ),
      Expanded(
          child: _containerCards(
              etiqueta: "HISTORIAL DE PAGOS", results: c.payments))
    ],
  );
}

Container _labelClient({
  String contenido: '',
}) {
  double fontSize = 16.0;
  if (contenido.length > 25) {
    fontSize = 17.0;
  }
  if (contenido.length > 30) {
    fontSize = 15.0;
  }

  return Container(
    padding: EdgeInsets.all(0.0),
    margin: EdgeInsets.only(top: 10, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Cliente: ",
          textAlign: TextAlign.right,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black54),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "$contenido",
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: fontSize, color: Colors.black54),
        ),
      ],
    ),
  );
}

Container _bigCircle(
    {String value: "0.0",
    String etiqueta: '',
    double widthAndheight: 120.0,
    double fontSize: 22}) {
  return Container(
    width: widthAndheight,
    height: widthAndheight,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white54,
      border: Border.all(color: Colors.black26),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$value",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
          Text(
            "$etiqueta",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: Colors.black38,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

Container _mediumCircle({String value: "0.0", String etiqueta: ''}) {
  double fontSize = 16;
  if (value.toString().length > 7) {
    fontSize = 16;
  }
  return _bigCircle(
      value: value,
      etiqueta: etiqueta,
      widthAndheight: 95.0,
      fontSize: fontSize);
}


Container _labelDetail({String description: ""}) {
  return Container(
    padding: EdgeInsets.all(2.0),
    margin: EdgeInsets.only(top: 10, bottom: 5),
    child: Text(
      "$description",
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.black54),
      maxLines: 3,
    ),
  );
}

Container _labelInformation({String contenido: '', String etiqueta: ''}) {
  return Container(
    padding: EdgeInsets.all(0.0),
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$contenido",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        Text(
          "$etiqueta",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ],
    ),
  );
}

Widget _line() {
  return Container(
    height: 30.0,
    width: 1.5,
    color: Colors.black12,
  );
}

Widget _containerCards({String etiqueta: '', List<PaymentHistory> results}) {
  return Container(
      child: Column(
    children: <Widget>[
      Divider( height: 1),
      Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: results.length,
            itemBuilder: (context, index) {              
              return SlidebleHistoryPay(pay: results[index]);
            }),
      ),
    ],
  ));
}
