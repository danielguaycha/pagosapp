import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/mobx/Payments/list_payments_mobx.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/payments/pay_receive.dart';
import 'package:pagosapp/src/models/payments/payment_List.dart';
import 'package:pagosapp/src/models/payments/payment_row.dart';
import 'package:pagosapp/src/models/payments/payment_store.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class ListsPaymentsPage extends StatefulWidget {
  final ClientHistory client;
  ListsPaymentsPage({Key key, @required this.client}) : super(key: key);

  @override
  _ListsPaymentsPageState createState() => _ListsPaymentsPageState();
}

ScrollController _scrollController;
double _scrollPosition;

PaymentList _payList;
bool _multiple = false;
List<Pay> _selectedPays = List();
List<DataPay> listaRecibida = List();
bool _loader = false;
String _error;
double _bottoForGrid = 0.0;
class _ListsPaymentsPageState extends State<ListsPaymentsPage> {
  // final ListPaymentsMobx listPaymentsMobx = ListPaymentsMobx();

  _scrollListener() {
    _scrollPosition = _scrollController.position.pixels;
    if (_scrollPosition == _scrollController.position.maxScrollExtent) {
      print("llego al fin");
      if(_bottoForGrid != 65.0){
        _bottoForGrid = 65.0;
        _rety();
        // listPaymentsMobx.up();
      }
    }

    if (_scrollPosition == _scrollController.position.minScrollExtent) {
      if(_bottoForGrid != 0.0){
        _bottoForGrid = 0.0;
        _rety();
      // listPaymentsMobx.down();
      }
      print("inicio");
    }
  }

  @override
  void initState() {
    this._getPays();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.client.name}"),
        actions: <Widget>[
          Visibility(
            visible: _multiple,
            child: IconButton(
              icon: Tooltip(
                  message: "Limpiar selección",
                  child: Icon(FontAwesomeIcons.times)),
              onPressed: () {
                _selectedPays.clear();
                _payList.payments.forEach((element) {
                  element.selected = false;
                });
                _multiple = false;
                setState(() {});
                // _select(choices[0]);
              },
            ),
          ),
        ],
      ),
      body: _customFutureBody(),
    );
  }

  // 1. fist load
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

  // 2. Render Body
  Widget _body() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          // SizedBox(height: 15.0,),
          Positioned(
            top: 15.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(dateForHumans2(_payList.fInicio)),
                SizedBox(width: 50.0,),
                Text(dateForHumans2(_payList.fFin)),
              ],
            ),
          ),
          // Divider(),
          // SizedBox(height: 15.0,),

          Positioned(
            top: 40.0,
            child: Text(
              money(_payList.total) + " / " + money(_payList.totalPagado),
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
          // SizedBox(height: 15.0,),
          // Divider(),
          // Positioned(
          //   top: 60.0,
          //             child:
          // RaisedButton(onPressed: null),
          // Container(
          //   width: 200.0,
          //   child: _grid()),
          //         Expanded(
          // child: Container(child: _grid())),
          // ),
          // Positioned(
          //   top: 60.0,
          //   child:
          // Observer(
          //   builder: (_) => 
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.only(
                    top: 65.0, bottom: _bottoForGrid),
                width: double.maxFinite,
                height: double.maxFinite,
                child: _grid()),
          // ),

          // Divider(),
          // Positioned(
          //   top: 60.0,
          //   child: Text("data")),
          // Positioned(top: 80.0, child: RaisedButton(onPressed: null))
          Positioned(
            bottom: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                    color: Colors.red[400],
                    shape: StadiumBorder(
                    ),
                    child: Text("No pagó"),
                    // color: Colors.red.withOpacity(0.0),

                    elevation: 0.0,
                    onPressed: () {
                      _noPago();
                    }),
                SizedBox(
                  width: 100.0,
                ),
                // Expanded(child: Container()),
                    RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      color: _selectedPays.length > 0 ? Colors.orange : Colors.green,
                      shape: CircleBorder(),
                      elevation: 0.0,
                      child:
                      _selectedPays.length > 0 ? 
                      Text(_selectedPays.length.toString()) : Icon(Icons.add),
                      //  Text(_selectedPays.length > 0
                      //     ? "Pagar ${_selectedPays.length}"
                      //     : "+"),
                      
                      onPressed: () {
                        if (_selectedPays.length <= 0) {
                          _generarAbono();
                        } else {
                          _generatePays();
                        }
                        setState(() {});
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Render Grid
  Widget _grid() {
    return GridView.builder(
        controller: _scrollController,
        itemCount: _payList.payments.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            crossAxisSpacing: 3,
            mainAxisSpacing: 9),
        itemBuilder: (context, index) {
          PaymentListChild p = _payList.payments[index];
          return Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        //                    <--- top side
                        color: _getColorStatus(p.status, p.diasMora, p.mora),
                        width: 4.0))),
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              textColor: _getColorStatus(p.status, p.diasMora, p.mora),
              disabledColor: Colors.grey[100],
              disabledElevation: 2,
              color: Colors.white,
              elevation: 3,
              onLongPress: p.status == PaymentList.COBRADO
                  ? null
                  : () {
                      _multiple = true;
                      _setSelected(p);
                      setState(() {});
                    },
              onPressed: p.status == PaymentList.COBRADO
                  ? null
                  : () async {
                      if (!_multiple) {
                        _selectedPays.clear();
                        _selectedPays
                            .add(Pay(pay: p.id, total: parseDouble(p.abono)));
                        _generatePays();
                      } else {
                        _setSelected(p);
                        setState(() {});
                      }
                    },
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(dateForHumans2(p.date),
                              style: TextStyle(
                                  color: _getColorStatus(
                                      p.status, p.diasMora, p.mora))),
                          Text(money(p.abono),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: _getColorStatus(
                                      p.status, p.diasMora, p.mora))),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _multiple && p.status != PaymentList.COBRADO,
                    child: Positioned(
                      bottom: -10,
                      right: -10,
                      child: Checkbox(
                          value: _payList.payments[index].selected,
                          onChanged: (v) {
                            if (v) {
                              _selectedPays.add(Pay(
                                  pay: _payList.payments[index].id,
                                  total: parseDouble(
                                      _payList.payments[index].abono)));
                            } else {
                              _selectedPays.removeWhere((element) =>
                                  element.pay == _payList.payments[index].id);
                            }
                            _payList.payments[index].selected = v;
                            setState(() {});
                          }),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  //**Http request
  void _getPays() async {
    _loader = true;
    _selectedPays.clear();
    setState(() {});
    Responser res = await PaymentProvider().listsPays(widget.client.credit);
    if (res.ok) {
      _payList = PaymentList.fromJson(res.data);
    } else {
      _error = res.message;
    }
    _loader = false;
    _rety();
  }

  void _rety() {
    setState(() {});
  }

  /* Métodos */
  void _setSelected(PaymentListChild p) {
    if (p.status == PaymentList.COBRADO) {
      return;
    }
    if (!p.selected) {
      _selectedPays.add(Pay(pay: p.id, total: parseDouble(p.abono)));
      p.selected = true;
    } else {
      _selectedPays.removeWhere((element) => element.pay == p.id);
      p.selected = false;
    }
  }

  void _generarAbono() async {
    String monto = await inputDialog(context,
        title: "Ingrese monto que desea abonar",
        decoration: "Cantidad \$",
        onlyDecimal: true);

    if (monto == null) return;

    Responser res = await PaymentProvider()
        .abonoPorCredito(widget.client.credit, parseDouble(monto));

    if (res.ok) {
      toast("Abono realizado con exito", type: 'ok');
      listaRecibida =
          List<DataPay>.from(res.data.map((x) => DataPay.fromJson(x)));
      _payList.totalPagado = _payList.totalPagado + parseDouble(monto);
      _changeInfoPays();
    } else {
      toast(res.message, type: 'err');
    }
  }

  void _noPago() async {
    var pay = _payList.payments.firstWhere((element) => element.status == 1);
    bool v = await confirm(context,
        title: "Confirmar incumplimiento",
        content:
            "¿Desea procesar el pago de la fecha ${dateForHumans2(pay.date)} con valor de ${money(pay.abono)} como NO PAGADO?");
    if (!v) {
      return;
    }
    Responser res = await PaymentProvider().abonoPorCredito(1, 0.0);

    if (res.ok) {
      toast("Transaccion procesada", type: 'ok');
      listaRecibida =
          List<DataPay>.from(res.data.map((x) => DataPay.fromJson(x)));
      _payList.totalPagado = _payList.totalPagado + 0.0;
      _changeInfoPays();
      print(listaRecibida.length);
    } else {
      toast(res.message, type: 'err');
    }
  }

  void _generatePays() async {
    String msg = "¿Está seguro que desea procesar este pago?";
    String title = "Confirmar";
    double total = 0;
    if (_selectedPays.length < 1) {
      return;
    }

    if (_selectedPays.length > 1) {
      _selectedPays.forEach((element) {
        total = element.total + total;
      });
      title = "Confirmar total ${money(total)}";
      msg =
          "¿Está seguro que desea procesar ${_selectedPays.length} pagos con un total de ${money(total)}?";
    }

    bool v = await confirm(context, title: title, content: msg);

    if (!v) {
      _selectedPays.clear();
      return;
    }

    Responser res = await PaymentProvider()
        .payForCredit(widget.client.credit, _selectedPays);

    // _selectedPays.clear();
    _payList.payments.forEach((element) {
      element.selected = false;
    });
    _multiple = false;

    if (_selectedPays.length == 1) {
      _payList.totalPagado = _payList.totalPagado + _selectedPays.first.total;
    }
    if (_selectedPays.length > 1) {
      _payList.totalPagado = _payList.totalPagado + total;
    }

    if (res.ok) {
      toast("Pagos realizados", type: 'ok');
      _changStatus();
      // _selectedPays.clear();
    } else {
      toast(res.message, type: 'err');
    }
  }

  void _changStatus() {
    for (var paysItem in _selectedPays) {
      _payList.payments.forEach((element) {
        if (element.id == paysItem.pay) {
          element.status = PaymentRow.COBRADO;
        }
      });
    }
    _selectedPays.clear();
    _rety();
  }

  void _changeInfoPays() {
    for (var paysRecibida in listaRecibida) {
      _payList.payments.forEach((element) {
        if (element.id == paysRecibida.id) {
          element.diasMora = paysRecibida.diasMora;
          element.abono = paysRecibida.abono;
          element.status = paysRecibida.status;
          element.mora = paysRecibida.mora;
          print("${element.mora} = ${paysRecibida.mora}");
        }
      });
    }

    listaRecibida.clear();
    // _selectedPays.clear();
    _rety();
  }

  Color _getColorStatus(int status, int dias, bool mora) {
    switch (status) {
      case 1:
        return Colors.black54;
        break;
      case 2:
        if (dias > 0 || mora == true) {
          return Colors.red;
        } else {
          return Colors.green;
        }
        break;
      case -1:
        return Colors.red;
        break;

      default:
        return Colors.black87;
    }
  }
}

//Respaldo

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:pagosapp/src/models/client/client_history.dart';
// import 'package:pagosapp/src/models/payments/pay_receive.dart';
// import 'package:pagosapp/src/models/payments/payment_List.dart';
// import 'package:pagosapp/src/models/payments/payment_row.dart';
// import 'package:pagosapp/src/models/payments/payment_store.dart';
// import 'package:pagosapp/src/models/responser.dart';
// import 'package:pagosapp/src/plugins/messages.dart';
// import 'package:pagosapp/src/providers/payment_provider.dart';
// import 'package:pagosapp/src/utils/exepctions.dart';
// import 'package:pagosapp/src/utils/utils.dart';
// import 'package:pagosapp/src/utils/validators.dart';

// class ListsPaymentsPage extends StatefulWidget {
//   final ClientHistory client;
//   ListsPaymentsPage({Key key, @required this.client}) : super(key: key);

//   @override
//   _ListsPaymentsPageState createState() => _ListsPaymentsPageState();
// }

// ScrollController _scrollController;
//   double _scrollPosition;

// PaymentList _payList;
// bool _multiple = false;
// List<Pay> _selectedPays = List();
// List<DataPay> listaRecibida = List();
// bool _loader = false;
// String _error;
// double _bottomForgrid = 0.0;
// class _ListsPaymentsPageState extends State<ListsPaymentsPage> {

//  _scrollListener() {
//   // setState(() {
//    _scrollPosition = _scrollController.position.pixels;
//    if(_scrollPosition == _scrollController.position.maxScrollExtent){
//      print("llego al fin");
//      _bottomForgrid = 60.0;
//     //  _rety();
//    }else{
//      _bottomForgrid = 0.0;
//     //  _rety();
//      print("No aun");
//    }
//    print("Position: $_scrollPosition");
// //  });
//  }

//   @override
//   void initState() {
//     this._getPays();
//      _scrollController = ScrollController();
//   _scrollController.addListener(_scrollListener);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // floatingActionButton: FloatingActionButton(
//       //   child: Text("${_selectedPays.length}", style: TextStyle(fontSize: 20.0),), //Icon(Icons.add),
//       //   onPressed: (){},
//       //   ),
//       appBar: AppBar(
//         title: Text("${widget.client.name}"),
//         actions: <Widget>[
//           Visibility(
//             visible: _multiple,
//             child: IconButton(
//               icon: Tooltip(
//                   message: "Limpiar selección",
//                   child: Icon(FontAwesomeIcons.times)),
//               onPressed: () {
//                 _selectedPays.clear();
//                 _payList.payments.forEach((element) {
//                   element.selected = false;
//                 });
//                 _multiple = false;
//                 setState(() {});
//                 // _select(choices[0]);
//               },
//             ),
//           ),
//         ],
//       ),
//       body: _customFutureBody(),
//     );
//   }
//   // 1. fist load
//   Widget _customFutureBody() {
//     if(_loader) {
//       return loader(text: "Cargando cobros...");
//     }

//     if(_error != null) {
//       return renderError(_error, () {});
//     }

//     if (_payList.payments.length <= 0) {
//       return renderNotFoundData("No hay cobros para estre crédito");
//     }

//     return _body();
//   }

//   // 2. Render Body
//   Widget _body() {
//     return Container(
//       width: double.maxFinite,
//       height: double.maxFinite,
//       child: Stack(
//         alignment: Alignment.topCenter,
//         children: <Widget>[
//           // SizedBox(height: 15.0,),
//           Positioned(
//             top: 15.0,
//                       child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 Text(dateForHumans2(_payList.fInicio)),
//                 Text(dateForHumans2(_payList.fFin)),
//               ],
//             ),
//           ),
//           // Divider(),
//           // SizedBox(height: 15.0,),

//           Positioned(
//             top: 40.0,
//                       child: Text(money(_payList.total) +
//                 " / " +
//                 money(_payList.totalPagado), style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold), ),
//           ),
//           // SizedBox(height: 15.0,),
//           // Divider(),
//           // Positioned(
//           //   top: 60.0,
//           //             child:
//           // RaisedButton(onPressed: null),
//                       // Container(
//                       //   width: 200.0,
//                       //   child: _grid()),
//               //         Expanded(
//               // child: Container(child: _grid())),
//           // ),
//           // Positioned(
//           //   top: 60.0,
//           //   child:
//             AnimatedContainer(
//               duration: Duration(milliseconds: 200),

//               padding: EdgeInsets.only(top: 65.0, bottom: _bottomForgrid),
//               width: double.maxFinite,
//               height: double.maxFinite,
//               child: _grid()),

//           // Divider(),
//           // Positioned(
//           //   top: 60.0,
//           //   child: Text("data")),
//             // Positioned(top: 80.0, child: RaisedButton(onPressed: null))
//           Positioned(
//             bottom: 10.0,
//                       child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               mainAxisSize: MainAxisSize.max,
//               children: <Widget>[
//                 RaisedButton(child: Text("No pagó"),
//                 // color: Colors.red.withOpacity(0.0),

//                 // elevation: 10.0,
//                  onPressed: () {
//                   _noPago();
//                 }),
//                 SizedBox(width: 100.0,),
//                 // Expanded(child: Container()),
//                 RaisedButton(
//                     child: Text(_selectedPays.length > 0
//                         ? "Pagar ${_selectedPays.length}"
//                         : "Abono"),
//                     onPressed: () {
//                       if (_selectedPays.length <= 0) {
//                         _generarAbono();
//                       } else {
//                         _generatePays();
//                       }
//                       setState(() {});
//                     }),
//               ],
//             ),
//           ),

//         ],
//       ),
//     );
//   }

//   // 3. Render Grid
//   Widget _grid() {
//     return GridView.builder(
//       controller: _scrollController,
//         itemCount: _payList.payments.length,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           childAspectRatio: 1,
//           crossAxisSpacing: 3,
//           mainAxisSpacing: 9
//         ),
//         itemBuilder: (context, index) {
//           PaymentListChild p = _payList.payments[index];
//           return Container(
//             padding: EdgeInsets.all(0),
//             decoration: BoxDecoration(
//                 border: Border(top: BorderSide( //                    <--- top side
//                   color: _getColorStatus(p.status, p.diasMora, p.mora), width: 4.0
//                 )
//               )
//             ),
//             child: RaisedButton(
//               padding: EdgeInsets.all(0),
//               textColor: _getColorStatus(p.status, p.diasMora, p.mora),
//               disabledColor: Colors.grey[100],
//               disabledElevation: 2,
//               color: Colors.white,
//               elevation: 3,
//               onLongPress: p.status == PaymentList.COBRADO ? null : () {
//                 _multiple = true;
//                 _setSelected(p);
//                 setState(() {});
//               },
//               onPressed: p.status == PaymentList.COBRADO ? null : () async {
//                 if (!_multiple) {
//                   _selectedPays.clear();
//                   _selectedPays.add(Pay(pay: p.id, total: parseDouble(p.abono)));
//                   _generatePays();
//                 } else {
//                   _setSelected(p);
//                   setState(() {});
//                 }
//               },
//               child:Stack(
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: <Widget>[
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Text(dateForHumans2(p.date), style: TextStyle(color: _getColorStatus(p.status, p.diasMora, p.mora))),
//                                 Text(money(p.abono), style: TextStyle(fontSize: 17, color: _getColorStatus(p.status, p.diasMora, p.mora))),
//                               ],
//                             ),

//                           ],
//                         ),
//                         Visibility(
//                           visible: _multiple && p.status != PaymentList.COBRADO,
//                           child: Positioned(
//                             bottom: -10,
//                             right: -10,
//                             child: Checkbox(
//                                 value: _payList.payments[index].selected,
//                                 onChanged: (v) {
//                                   if (v) {
//                                     _selectedPays.add(Pay(
//                                         pay: _payList.payments[index].id,
//                                         total: parseDouble(_payList
//                                             .payments[index].abono)));
//                                   } else {
//                                     _selectedPays.removeWhere((element) => element.pay == _payList.payments[index].id);
//                                   }
//                                   _payList.payments[index].selected = v;
//                                   setState(() {});
//                                 }),
//                           ),
//                         )
//                       ],
//                     ),
//                 ),
//           );
//         });
//   }

//   //**Http request
//   void _getPays() async {
//     _loader = true;
//     _selectedPays.clear();
//     setState(() {});
//     Responser res = await PaymentProvider().listsPays(widget.client.credit);
//     if(res.ok) {
//       _payList = PaymentList.fromJson(res.data);
//     } else {
//       _error = res.message;
//     }
//     _loader = false;
//     _rety();
//   }

//   void _rety(){
//     setState(() {
//     });
//   }

//   /* Métodos */
//   void _setSelected(PaymentListChild p) {
//     if(p.status == PaymentList.COBRADO) {return;}
//     if(!p.selected) {
//       _selectedPays.add(Pay(pay: p.id, total: parseDouble(p.abono)));
//       p.selected = true;
//     } else {
//       _selectedPays.removeWhere((element) => element.pay == p.id);
//       p.selected = false;
//     }
//   }

//   void _generarAbono() async {
//     String monto = await inputDialog(context,
//         title: "Ingrese monto que desea abonar", decoration: "Cantidad \$", onlyDecimal: true);

//     if(monto == null) return;

//     Responser res =
//         await PaymentProvider().abonoPorCredito(widget.client.credit, parseDouble(monto));

//     if (res.ok) {
//       toast("Abono realizado con exito", type: 'ok');
//       listaRecibida = List<DataPay>.from(res.data.map((x) => DataPay.fromJson(x)));
//       _payList.totalPagado = _payList.totalPagado + parseDouble(monto);
//       _changeInfoPays();
//     } else {
//       toast(res.message, type: 'err');
//     }
//   }

//   void _noPago() async {
//     var pay = _payList.payments.firstWhere((element) => element.status == 1);
//     bool v = await confirm(context, title: "Confirmar incumplimiento", content: "¿Desea procesar el pago de la fecha ${dateForHumans2(pay.date)} con valor de ${money(pay.abono)} como NO PAGADO?");
//     if(!v){
//       return;
//     }
//     Responser res =
//         await PaymentProvider().abonoPorCredito(1, 0.0);

//     if (res.ok) {
//       toast("Transaccion procesada", type: 'ok');
//       listaRecibida = List<DataPay>.from(res.data.map((x) => DataPay.fromJson(x)));
//       _payList.totalPagado = _payList.totalPagado + 0.0;
//       _changeInfoPays();
//       print(listaRecibida.length);
//     } else {
//       toast(res.message, type: 'err');
//     }
//   }

//   void _generatePays() async {
//     String msg = "¿Está seguro que desea procesar este pago?";
//     String title = "Confirmar";
//     double total = 0;
//     if (_selectedPays.length < 1) {
//       return;
//     }

//     if (_selectedPays.length > 1) {
//       _selectedPays.forEach((element) {
//         total = element.total + total;
//       });
//       title = "Confirmar total ${money(total)}";
//       msg =
//           "¿Está seguro que desea procesar ${_selectedPays.length} pagos con un total de ${money(total)}?";
//     }

//     bool v = await confirm(context, title: title, content: msg);

//     if (!v) {
//       _selectedPays.clear();
//       return;
//     }

//     Responser res = await PaymentProvider().payForCredit(widget.client.credit, _selectedPays);

//     // _selectedPays.clear();
//     _payList.payments.forEach((element) { element.selected = false; });
//     _multiple = false;

//     if(_selectedPays.length == 1){
//       _payList.totalPagado = _payList.totalPagado + _selectedPays.first.total;
//     }
//     if(_selectedPays.length > 1){
//       _payList.totalPagado = _payList.totalPagado + total;
//     }

//     if (res.ok) {
//       toast("Pagos realizados", type: 'ok');
//       _changStatus();
//       // _selectedPays.clear();
//     } else {
//       toast(res.message, type: 'err');
//     }
//   }

//   void _changStatus(){
//     for (var paysItem in _selectedPays) {
//       _payList.payments.forEach((element) {
//         if(element.id == paysItem.pay){
//           element.status = PaymentRow.COBRADO;
//         }
//       });
//     }
//     _selectedPays.clear();
//     _rety();
//   }

//   void _changeInfoPays(){
//     for (var paysRecibida in listaRecibida) {
//       _payList.payments.forEach((element) {
//         if(element.id == paysRecibida.id){
//           element.diasMora = paysRecibida.diasMora;
//           element.abono = paysRecibida.abono;
//           element.status = paysRecibida.status;
//           element.mora = paysRecibida.mora;
//           print("${element.mora} = ${paysRecibida.mora}");
//         }
//       });
//     }

//     listaRecibida.clear();
//     // _selectedPays.clear();
//     _rety();
//   }

//   Color _getColorStatus(int status, int dias, bool mora) {
//     switch (status) {
//       case 1:
//         return Colors.black54;
//         break;
//       case 2:
//         if(dias > 0 || mora == true){
//           return Colors.red;
//         }else{
//           return Colors.green;
//         }
//         break;
//       case -1:
//         return Colors.red;
//         break;

//       default:
//         return Colors.black87;
//     }
//   }
// }
