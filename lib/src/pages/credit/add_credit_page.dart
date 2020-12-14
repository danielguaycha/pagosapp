import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/credit.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/pages/client/edit_client_page.dart';
import 'package:pagosapp/src/pages/client/list_client_page.dart';
import 'package:pagosapp/src/pages/client/new_client_page.dart';
import 'package:pagosapp/src/pages/credit/widgets/credit_calc_component.dart';
import 'package:pagosapp/src/pages/home_page.dart';
import 'package:pagosapp/src/pages/payments/show_list_payments.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/plugins/progress_loader.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/providers/credit_provider.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class AddCreditPage extends StatefulWidget {
  final ClientHistory clientHistory;
  AddCreditPage({Key key, this.clientHistory}) : super(key: key);

  @override
  _AddCreditPageState createState() => _AddCreditPageState();
}

class _AddCreditPageState extends State<AddCreditPage> {
  ClientHistory _client;
  Credit _credit;
  ProgressLoader _loader;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color _one = Style.primary[600];
  Color _two = Style.primary[500];

  @override
  void initState() {
    this._credit = new Credit();
    super.initState();
    if (widget.clientHistory != null) {
      _client = widget.clientHistory;
    }
  }

  void _onSubmit() async {
    if (!_validate()) return;
    int isOk = await Alert.confirm(context,
        title: "Confirmar",
        content:
            "¿Está seguro que desea guardar este crédito?\nMonto: ${money(_credit.monto)} | Utilidad: ${_credit.utilidad}\nPlazo: ${_credit.plazo}\nCobro: ${_credit.cobro}\nCliente: ${_client.name} ");
    if (isOk == 1) {
      return;
    }
    _loader.show(
        msg:
            "Procesando crédito, espere...\n\nSi ha proporcionado una prenda, es probable que tome algo de tiempo");
    _credit.personId = _client.id;

    Responser res = await CreditProvider().store(_credit);
    if (res.ok) {
      _client.credit = res.data['id'];
      _loader.hide();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowListPaymentPage(
                client: _client,
              )));
      _scaffoldKey.currentState
          .showSnackBar(customSnack("Crédito procesado con éxito"));
      _credit = new Credit();
      setState(() {});
    } else {
      _scaffoldKey.currentState
          .showSnackBar(customSnack(res.message, type: 'err'));
      _loader.hide();
      setState(() {});
    }

  }

  bool _validate() {
    if (_client == null) {
      toast("Seleccione un cliente");
      return false;
    }
    if (_credit.plazo == null ||
        _credit.cobro == null ||
        _credit.utilidad == null) {
      toast("Plazo, Recaudación y Utilidad son requeridos");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_loader == null) {
      _loader = new ProgressLoader(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            expandedHeight: _client == null ? 200 : 50,
            forceElevated: true,
            elevation: 8,
            snap: false,
            pinned: true,
            stretch: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(
                      builder: (context) => HomePage()) , (route) => false);
                      },
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title:
                  Text((_client == null ? "Nuevo Crédito" : "${_client.name}"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      )),
              background: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomLeft,
                          colors: [_one, _two])),
                  child: (_client == null) ? _buttonsClient() : null),
            ),
            actions: <Widget>[
              Visibility(
                  visible: _client != null,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.userEdit, size: 16),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditClientPage(
                                    clientId: _client.id,
                                    status: 0,
                                  )));
                    },
                    tooltip: 'Editar cliente',
                  )),
              Visibility(
                  visible: _client != null,
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.userMinus, size: 16),
                    onPressed: () {
                      setState(() {
                        _client = null;
                      });
                    },
                    tooltip: 'Remover cliente',
                  )),
            ],
          ),
          SliverToBoxAdapter(
            child: _creditDataOrBlank(),
          ),
        ],
      ),
      floatingActionButton: _client == null
          ? null
          : FloatingActionButton(onPressed: _onSubmit, child: Icon(Icons.save)),
    );
  }

  _creditDataOrBlank() {
    if (_client == null) {
      return Container(
          margin: EdgeInsets.only(top: 60),
          child: Center(
              child: Text("Buscar o seleccionar un cliente para empezar",
                  style: TextStyle(color: Colors.grey[500]))));
    }
    return CreditCalcComponent(credit: _credit);
  }

  _buttonsClient() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.all(15),
                onPressed: () async {
                  var client = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewClientPage()));
                  if (client != null) {
                    setState(() {
                      _client = client;
                    });
                    toast("Cliente agregado con éxito");
                  }
                },
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.userPlus, color: Colors.white60),
                    SizedBox(height: 10),
                    Text("Agregar cliente",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white70)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.all(15),
                onPressed: () async {
                  var client = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListClientPage(
                                returning: true,
                              )));
                  if (client != null) {
                    setState(() {
                      _client = client;
                    });
                  }
                },
                child: Column(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.search, color: Colors.white60),
                    SizedBox(height: 10),
                    Text("Seleccionar Cliente",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
