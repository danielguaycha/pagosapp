import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_it/share_it.dart';

class ShowListPaymentPage extends StatefulWidget {
  final ClientHistory client;
  ShowListPaymentPage({Key key, @required this.client}) : super(key: key);

  @override
  _ShowListPaymentPageState createState() => _ShowListPaymentPageState();
}

class _ShowListPaymentPageState extends State<ShowListPaymentPage> {
  PaymentList _payList;
  bool _loader = false;
  String _error;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    this._getPays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, 'credit_add'),
        ),
        title: Text("${widget.client.name}"),
        actions: <Widget>[
        ],
      ),
      body: _customFutureBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          String fileName = DateTime.now().toIso8601String();
          var path = '$appDocPath/$fileName.png';
          print(path);
          screenshotController.capture(path:path).then((File image) {
            //Capture Done
            ShareIt.file(path: path, type: ShareItFileType.image);
          }).catchError((onError) {
              toast("Error al capturar la imagen", type: "err");
          });
        },
        child: Icon(Icons.share),
      ),
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
      return renderNotFoundData("No hay cobros para este crédito");
    }

    return _body();
  }

  // 2. Render Body
  Widget _body() {
    return  Screenshot(
      controller: screenshotController,
      child: Container(
        color: Colors.white,
        child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(dateForHumans2(_payList.fInicio)),
                      Text(dateForHumans2(_payList.fFin)),
                    ],
                  ),
                Text(money(_payList.monto) + " / " + money(_payList.total),
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
                SizedBox(height: 5),
                Center(child: Text("${money(_payList.payments[0].total)} x ${_payList.payments.length}")),
                SizedBox(height: 10),
                Expanded(child: _grid()),
              ],
        ),
      ),
    );
  }

  // 3. Render Grid
  Widget _grid() {
    return GridView.builder(
        itemCount: _payList.payments.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.4,
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
                        width: 1.0))),
            child: RaisedButton(
              padding: EdgeInsets.all(0),
              disabledColor: Colors.white,
              disabledTextColor: Style.primary,
              disabledElevation: 2,
              color: Colors.white,
              elevation: 3,
              onPressed: () {  },
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
                          Text(dateForHumans2(p.date), style: TextStyle(fontWeight: FontWeight.w400),),
                          Text("#${index+1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                          Text(money(p.total),
                              style: TextStyle(fontSize: 17,color: Style.primary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
  //**Http request
  void _getPays() async {
    _loader = true;
    setState(() {});
    Responser res = await PaymentProvider().listsPays(widget.client.credit, all: true);
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

}