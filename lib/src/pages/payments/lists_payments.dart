import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/payments/list_payments.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/providers/payment_provider.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class ListsPaymentsPage extends StatefulWidget {
  final int clientId;
  ListsPaymentsPage({Key key, @required this.clientId}) : super(key: key);

  @override
  _ListsPaymentsPageState createState() => _ListsPaymentsPageState();
}

class Recaudacion {
  String date;
  double value;
  bool pay;

  Recaudacion(this.date, this.value, this.pay);
}

List<Recaudacion> list = List();
DataPaymentClient dataPaymentClient;
bool multipleSelect = false;
List<int> selectedList = List();
List<PaymentRequest> selectedPayments = List();

class _ListsPaymentsPageState extends State<ListsPaymentsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataPays(1);

    list.add(Recaudacion("01-01-2020", 10.0, false));
    list.add(Recaudacion("02-01-2020", 10.0, false));
    list.add(Recaudacion("03-01-2020", 10.0, false));
    list.add(Recaudacion("04-01-2020", 10.0, false));
    list.add(Recaudacion("05-01-2020", 10.0, false));
    list.add(Recaudacion("06-01-2020", 10.0, false));
    list.add(Recaudacion("07-01-2020", 10.0, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${dataPaymentClient.name}"),
        actions: <Widget>[
          Visibility(
            visible: selectedPayments.length > 0,
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                selectedPayments.clear();
                dataPaymentClient.payments.forEach((element) { element.mora = false;});
                multipleSelect = false;
                setState(() {
                  
                });
                // _select(choices[0]);
              },
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(dateForHumans2(dataPaymentClient.fInicio)),
            Text(dateForHumans2(dataPaymentClient.fFin)),
          ],
        ),
        Divider(),
        Text(money(dataPaymentClient.total) +
            " / " +
            money(dataPaymentClient.totalPagado)),
        Divider(),
        Expanded(child: Container(child: _grid())),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(child: Text("No pago"), onPressed: () {}),
            RaisedButton(
                child: Text(selectedPayments.length > 0
                    ? "Pagar ${selectedPayments.length}"
                    : "Abono"),
                onPressed: () {
                  if(selectedPayments.length <= 0){
                    _generarAbono();
                  }else{
                  _generatePays();
                  }
                  // selectedPayments.clear();

                  setState(() {});
                }),
          ],
        ),
      ],
    );
  }

  Widget _grid() {
    return GridView.builder(
        itemCount: dataPaymentClient.payments.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(0.0),
            margin: EdgeInsets.all(0.0),
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                    color: getColorStatus(
                        dataPaymentClient.payments[index].status),
                    width: 1.0)),
            child: RaisedButton(
              padding: EdgeInsets.only(top: 10.0),
              textColor:
                  getColorStatus(dataPaymentClient.payments[index].status),
              color: Colors.white,
              elevation: 0.0,
              onLongPress: () {
                // dataPaymentClient.payments[index].mora = true;              
                multipleSelect = true;
                setState(() {});
              },
              onPressed: () async {
                if (!multipleSelect) {
                  // if(selectedPayments.length > 0){
                  selectedPayments.clear();
                  selectedPayments.add(PaymentRequest(
                      id: dataPaymentClient.payments[index].id,
                      total: parseDouble(
                          dataPaymentClient.payments[index].abono)));
                  _generatePays();
                  // }
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(dateForHumans2(
                              dataPaymentClient.payments[index].date)),
                          Text(money(dataPaymentClient.payments[index].abono)),
                        ],
                      )
                    ],
                  ),
                  Visibility(
                    visible: (dataPaymentClient.payments[index].status == 1 &&
                        multipleSelect),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          // visible: !list[index].pay,
                          child: Checkbox(
                              value: dataPaymentClient.payments[index].mora,
                              onChanged: (v) {
                                if (v) {
                                  selectedPayments.add(
                                    PaymentRequest(
                                    id: dataPaymentClient.payments[index].id,
                                    total: parseDouble(dataPaymentClient.payments[index].abono
                                    )));

                                  // selectedPayments.add(dataPaymentClient.payments[index]);
                                  // selectedList.add(index);
                                } else {
                                  print("Deseleccion");

                                  selectedPayments.removeWhere((element) => element.id == dataPaymentClient.payments[index].id);


                                  // selectedPayments.remove(
                                  //   PaymentRequest(
                                  //   id: dataPaymentClient.payments[index].id,
                                  //   total: double.parse(dataPaymentClient.payments[index].abono
                                  //   )));

                                  // selectedPayments.remove(dataPaymentClient.payments[index]);

                                  // selectedList.remove(index);
                                }
                                dataPaymentClient.payments[index].mora = v;
                                print("Value: $v");
                                setState(() {});
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  /* Metodos */
  void _loadDataPays(int id) async {
    Responser res = await PaymentProvider().listsPays(id);

    if (res.ok) {
      var results = res.data;
      dataPaymentClient = DataPaymentClient.fromJson(results);
    } else {
      toast(res.message, type: 'err');
    }

    setState(() {});
  }

  void _generarAbono() async {
    String monto = await inputDialog(context, title: "Ingrese el monto", decoration: "Cantidad");

    Responser res = await PaymentProvider().abonoPorCredito(1, parseDouble(monto));

    if (res.ok) {
      toast(res.message, type: 'ok');
    } else {
      toast(res.message, type: 'err');
    }

  }

  void _generatePays() async {
    String msg = "¿Está seguro que desea procesar este pago?";
    String title = "Confirmar";
    double total = 0;
    if(selectedPayments.length < 1){
      return;
    }

    if(selectedPayments.length > 1){
      selectedPayments.forEach((element) {total = element.total + total; });
      title = "Confirmar total ${money(total)}";
      msg = "¿Está seguro que desea procesar ${selectedPayments.length} pagos con un total de ${money(total)}?";
    }

    
    bool v = await confirm(context,
    title: title,
        content: msg);

    if (!v) {
      return;
    }

    // int id, List<Payment> pay) async {
    Responser res = await PaymentProvider().payForCredit(1, selectedPayments);

    selectedPayments.clear();
    dataPaymentClient.payments.forEach((element) { element.mora = false;});
    multipleSelect = false;

    if (res.ok) {
      toast("Pagos realizados", type: 'ok');
      selectedPayments.clear();
    } else {
      toast(res.message, type: 'err');
    }
    


  }

  Color getColorStatus(int status) {
    switch (status) {
      case 1:
        return Colors.black;
        break;
      case 2:
        return Colors.green;
        break;
      case -1:
        return Colors.red;
        break;

      default:
        return Colors.black;
    }
  }
}
