import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/payments/payment_List.dart';
import 'package:pagosapp/src/models/payments/payment_list_child.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class ListPaymentPage extends StatefulWidget {
  final ClientHistory client;
  ListPaymentPage({Key key, @required this.client}) : super(key: key);

  @override
  _ListPaymentPageState createState() => _ListPaymentPageState();
}

class _ListPaymentPageState extends State<ListPaymentPage> {

  bool _loader = false;
  PaymentList _payList;
  List<PaymentListChild> _listaRecibida = List();
  String _error;

  @override
  void initState() {
    this._getPays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.client.name}"),
      ),
      body: _customFutureBody(),
      floatingActionButton: _payList != null && _payList.payments.length > 0 ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          if (_payList.payments.length > 0)
            _abono();
        },
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _payList != null && _payList.payments.length > 0 ?  BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(FontAwesomeIcons.strikethrough, color: Colors.red[400]),
              label: Text(" No pagó", style: TextStyle(color: Colors.white54
              ),),
              onPressed: _noPay,
            )
          ],
        ),
      ): null,
    );
  }

  Widget _customFutureBody() {
    if (_loader) {
      return loader(text: "Cargando cobros...");
    }

    if (_error != null) {
      return renderError(_error, () {});
    }

    if (_payList.payments.length <= 0) {
      return renderNotFoundData("No hay cobros para estre crédito");
    }

    return _body();
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        //* fecha de inicio y de fin
        _dates(),
        SizedBox(height: 10,),
        //* Dinero total
        _saldos(),
        SizedBox(height: 10),
        Divider(height: 1),
        //*Listado de pagos - historial
        _list()
      ],
    );
  }

  //**Http request
  void _getPays() async {
    _loader = true;
    setState(() {});
    Responser res = await PaymentProvider().listsPays(widget.client.credit, all: false);
    if (res.ok) {
      _payList = PaymentList.fromJson(res.data);
      _setLastDescription();
    } else {
      _error = res.message;
    }
    _loader = false;
    setState(() {});
  }

  void _pay({payId}) async{
    bool v = await confirm(context, title: "Confirmar Pago", content: "¿Esta seguro de que desea procesar el pago?");
    if (!v) {return;}

    Responser res = await PaymentProvider().pay(creditId: widget.client.credit, payId: payId);
    if (res.ok) {
      toast("Pago procesado con éxito", type: 'ok');

      _listaRecibida =
      List<PaymentListChild>.from(res.data.map((x) => PaymentListChild.fromJson(x)));
      //_payList.totalPagado = _payList.totalPagado + parseDouble(monto);
      _changeInfoPays();
    } else {
      toast(res.message, type: 'err');
    }
  }

  void _abono({payId}) async {
    String monto = await inputDialog(context,
        title: "Ingrese monto que desea abonar",
        decoration: "Cantidad \$",
        onlyDecimal: true);

    if (monto == null) return;

    Responser res = await PaymentProvider()
        .abono(widget.client.credit, parseDouble(monto), payId: payId);
    if (res.ok) {
      toast("Abono realizado con éxito", type: 'ok');
      _listaRecibida =
      List<PaymentListChild>.from(res.data.map((x) => PaymentListChild.fromJson(x)));
      _changeInfoPays();
    } else {
      toast(res.message, type: 'err');
    }
  }

  void _noPay() async{
    var pay = _payList.payments.firstWhere((e) => e.status == 1, orElse: () => null );
    if(pay == null) {
      toast("No hay pagos pendientes hoy");
      return;
    }
    bool v = await confirm(context,
        title: "Confirmar incumplimiento",
        content:
        "¿Desea procesar el pago de la fecha ${dateForHumans2(pay.date)} con valor de ${money(pay.abono)} como NO PAGADO?");
    if (!v) {
      return;
    }
    Responser res = await PaymentProvider().abono(1, 0.0);

    if (res.ok) {
      toast("Pago marcado como MORA", type: 'ok');
      _listaRecibida = List<PaymentListChild>.from(res.data.map((x) => PaymentListChild.fromJson(x)));
      //_payList.totalPagado = _payList.totalPagado + 0.0;
      _changeInfoPays();
    } else {
      toast(res.message, type: 'err');
    }
  }

  //**Widgets
  Widget _list(){
    return Expanded(
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            PaymentListChild pay = _payList.payments[index];
            return ListTile(
              title: Row(
                children: <Widget>[
                  Text("${dateForHumans2(pay.date)}", style: TextStyle(color: _getColor(pay.status)),),
                  Text(" ---- ", style: TextStyle(color: Colors.black12),),
                  Text("${money(pay.abono)}", style: TextStyle(color: _getColor(pay.status), fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Container(alignment: Alignment.centerRight,
                        child: Text("${pay.description != null ? pay.description : ''}", style: TextStyle(fontSize: 14, color: _getColor(pay.status)),)),
                  )
                ],
              ),
              // pay.status == 1 ? () { _pay(payId: pay.id); } : null
              onTap: (pay.status == 1 || (pay.status == PaymentListChild.COBRADO && isToday(pay.date))) ? () => _onTap(pay): null,
            );

          },
          itemCount: _payList.payments.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(height: 1);
          },)
    );
  }

  Widget _dates(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(dateForHumans2(_payList.fInicio)),
          Text(dateForHumans2(_payList.fFin)),
        ],
      ),
    );
  }

  Widget _saldos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text("Total a pagar", style: TextStyle(color: Colors.black38),),
            Text("${money(_payList.total)}", style: TextStyle(color: Style.secondary[800], fontWeight: FontWeight.w600, fontSize: 16),)
          ],
        ),
        Text("-"),
        Column(
          children: <Widget>[
            Text("Pagado", style: TextStyle(color: Colors.black38),),
            Text("${money(_payList.totalPagado)}", style: TextStyle(color: Style.secondary[800], fontWeight: FontWeight.w600, fontSize: 16),)
          ],
        ),
        Text("="),
        Column(
          children: <Widget>[
            Text("Pendiente", style: TextStyle(color: Colors.black38),),
            Text("${money(_payList.total - _payList.totalPagado)}", style: TextStyle(color: Style.primary[800], fontWeight: FontWeight.w600, fontSize: 16),)
          ],
        )
      ],
    );
  }

  Color _getColor(status){
      switch (status) {
        case PaymentListChild.COBRADO :
          return Colors.green;
        case PaymentListChild.NO_PAID:
          return Colors.red;
        case PaymentListChild.PARTIAL_PAID:
          return Colors.orange[700];
        default: return Colors.black87;
      }
  }

  //**Others functions
  void _changeInfoPays() {
    for (var paysRecibida in _listaRecibida) {      
      _payList.payments.forEach((element) {

        if (element.id == paysRecibida.id) {
          element.abono = paysRecibida.abono;
          element.status = paysRecibida.status;
          element.mora = paysRecibida.mora;
          element.pending = paysRecibida.pending;
          element.datePayment = paysRecibida.datePayment;
          element.description = element.getDescription();
          if(element.status != 1) {
            _payList.totalPagado = _payList.totalPagado + parseDouble(element.abono);
          }
        } else {
          if (element.description != null && element.description.toLowerCase().contains("pendiente")) {
            element.description = element.getDescription();
          }
        }        
      });
    }

    _listaRecibida.clear();
    _setLastDescription();
    // _selectedPays.clear();
    setState(() {});
  }

  void _setLastDescription() {
    var el = _payList.payments.lastWhere((element) => element.status != 1 && element.pending > 0, orElse: () => null);
    if (el!=null) {
      el.description = "Pendiente ${money(el.pending)}";
    }
  }

   _onTap(PaymentListChild p) {
    if (p.status == 1)
      _pay(payId: p.id);
    if(p.status == PaymentListChild.COBRADO) {
      if(isToday(p.date)) {
        _abono(payId: p.id);
      }
    }
    return null;
  }
}