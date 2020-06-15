import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/payments/payment_row.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/pages/payments/widgets/slidable_pay.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';
class ListPaymentPage extends StatefulWidget {
  ListPaymentPage({Key key}) : super(key: key);

  @override
  _ListPaymentPageState createState() => _ListPaymentPageState();
}

class _ListPaymentPageState extends State<ListPaymentPage> {

  List<PaymentRow> _pays;
  PaymentProvider _paymentProvider = PaymentProvider();
  bool _loader = false;
  String _error;  
  String _date = "";

  @override
  void initState() {
    this._pays = List();
    this._loadPays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recaudacion ${_date != '' ? "| $_date" : '' }'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selecionarFecha(context);
            },
          ),
        ],
      ),
      body: _listPays(),
    );
  }

  Widget _listPays() {
    if(_loader) {
      return loader(text: "Cargando pagos...");
    }

    if(_error != null) {
      return renderError(_error, () {});
    }

    if (_pays.length <= 0) {
      return renderNotFoundData("No hay cobros para hoy");
    }

    return _buildItems(context);   
  }

  Widget _buildItems(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Container(
              height: 0.0,
              width: 0.0,
            ),
            itemCount: _pays.length,
            itemBuilder: (BuildContext context, int index) {                        
              return SlideablePay(pay: _pays[index]);
            },
          ),
        ),        
      ],
    );
  }

  void _loadPays() async {
     setState(() {
      _pays.clear();
      _loader = true;
    });
    Responser res = await _paymentProvider.listPaymentsForDay(_date);
    if(res.ok) {
      var results = res.data;
      for(var i=0; i<results.length; i++) {
         _pays.add(PaymentRow.fromJson(json.encode((results[i]))));   
      }
    } else {
      _error = res.message;      
      print("El error pasa por aqui $_error");
    }
    _loader = false;
    setState(() {});
  }

  void _selecionarFecha(BuildContext context) async {
    DateTime picked = await showDatePicker(
      helpText: "Seleccione el dia",
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2100),
      locale: Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _date = dateForHumans(picked);
        _loadPays();
        //_paymentsClients.clear();
      });
    }
  }

}
