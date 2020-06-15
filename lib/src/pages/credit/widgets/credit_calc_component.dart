import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagosapp/src/config.dart';
import 'package:pagosapp/src/models/client.dart';
import 'package:pagosapp/src/models/credit.dart';
import 'package:pagosapp/src/pages/client/list_client_page.dart';
import 'package:pagosapp/src/plugins/file_manager.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/utils/utils.dart';
import 'package:pagosapp/src/utils/validators.dart';

class CreditCalcComponent extends StatefulWidget {
  final Credit credit;

  CreditCalcComponent({Key key, this.credit});

  @override
  _CreditCalcComponentState createState() => _CreditCalcComponentState();
}

class _CreditCalcComponentState extends State<CreditCalcComponent> {
  TextEditingController _txtMonto = TextEditingController();
  Credit _credit;
  Client _guarantor;
  bool _loadPrenda = false;

  FocusNode _inputMonto = new FocusNode();
  FocusNode _node = new FocusNode();

  @override
  void initState() {
    _credit = widget.credit;
    _credit.monto = 100;
    _inputMonto.addListener(() {
      if (_inputMonto.hasFocus) {
        _txtMonto.selection =
            TextSelection(baseOffset: 0, extentOffset: _txtMonto.text.length);
      }
    });
    super.initState();
  }

  void _calcular() {
    setState(() {
      _credit.calcular();
    });
  }

  Widget _comboMonto() {
    return _focus(
      child: DropdownButtonFormField(
        value: _credit.monto,
        // hint: new Text("Tipo de cobro"),
        items: montos(),
        isDense: true,
        decoration: InputDecoration(
            icon: Icon(
              FontAwesomeIcons.dollarSign,
              color: Colors.orange,
            ),
            labelText: 'Crédito'),
        onSaved: (v) => _credit.cobro = v,
        validator: (v) {
          if (v == null || v == '') return 'Selecciona un monto';
          return null;
        },
        onChanged: (opt) {
          setState(() {
            _credit.monto = parseDouble(opt);
            //_changeCobro = false;
          });
          _calcular();
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> montos() {
    int init = 25;
    int end = 1000;
    List<DropdownMenuItem<int>> lista = new List();
    for (var i = init; i <= end; i = i + 25) {
      lista
        ..add(DropdownMenuItem(
          child: Text('$i'),
          value: i,
        ));
    }
    return lista;
  }

  // Plazo
  Widget _comboPlazo(context) {
    return _focus(
        child: DropdownButtonFormField(
      value: _credit.plazo,
      isDense: true,
      items: listItems(plazos),
      itemHeight: 50.0,
      decoration: InputDecoration(
        icon: Icon(
          FontAwesomeIcons.calendarWeek,
          color: Colors.orange,
        ),
        labelText: 'Plazo',
      ),
      onSaved: (v) {},
      validator: (v) {
        if (v == null || v == '') return 'Selecciona un plazo';
        return null;
      },
      onChanged: (opt) {
        setState(() {
          _credit.plazo = opt;
          //_changeCobro = true;
        });
        _calcular();
      },
    ));
  }

  // Cobro
  Widget _comboCobro(context) {
    return _focus(
      child: DropdownButtonFormField(
        value: _credit.cobro,
        // hint: new Text("Tipo de cobro"),
        items: listItems(cobros),
        isDense: true,
        decoration: InputDecoration(
            icon: Icon(
              FontAwesomeIcons.calendarTimes,
              color: Colors.orange,
            ),
            labelText: 'Recaudación'),
        onSaved: (v) => _credit.cobro = v,
        validator: (v) {
          if (v == null || v == '')
            return 'Selecciona un periodo de recaudación';
          return null;
        },
        onChanged: (opt) {
          setState(() {
            _credit.cobro = opt;
            //_changeCobro = false;
          });
          _calcular();
        },
      ),
    );
  }

  // utilidad
  Widget _comboUtilidad(context) {
    return _focus(
      child: DropdownButtonFormField(
        value: _credit.utilidad,
        isDense: true,
        items: listItemsNormal(utilidad, '%'),
        decoration: InputDecoration(
            icon:
                Icon(FontAwesomeIcons.percent, size: 19, color: Colors.orange),
            labelText: 'Interés %'),
        onChanged: (opt) {
          setState(() {
            _credit.utilidad = parseDouble(opt);
          });
          _calcular();
        },
        validator: (v) {
          if (_credit.utilidad == null) {
            return 'Seleccione una interés';
          }
          return null;
        },
      ),
    );
  }

  /*CÁLCULOS*/
  Widget _calcContainer(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _circleInfo("Cuotas", _credit.nPagos, Colors.red[900]),
            _circleInfo("Interés", money(_credit.totalUtilidad),
                Colors.blueGrey[600]),
            _circleInfo("Inicio Crédito", dateForHumans2(_credit.fInicio),
                Colors.black38),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _circleInfo("A pagar", money(_credit.pagosDe), Colors.blue,
                extra: (_credit.pagosDeLast != null)
                    ? "${money(_credit.pagosDeLast)}"
                    : ''),
            _circleInfo("Total", money(_credit.total), Colors.green),
            _circleInfo(
                "Fin Crédito", dateForHumans2(_credit.fFin), Colors.black38),
          ],
        ),
      ],
    );
  }

  Widget _circleInfo(String title, Object info, Color color,
      {String extra: ''}) {
    return Container(
      padding: EdgeInsets.all(2.5),
      margin: EdgeInsets.only(top: 2, bottom: 2),
      constraints: BoxConstraints.tightFor(width: 120, height: 62),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(7))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("$title", style: TextStyle(color: Colors.black45)),
          Text(
            "$info",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: color),
          ),
          (extra != '\$ 0.00')
              ? Text("$extra", style: TextStyle(fontSize: 10))
              : Container(
                  child: null,
                )
        ],
      ),
    );
  }

  // focus
  Widget _focus({Widget child}) {
    return Focus(
        focusNode: _node,
        onFocusChange: (bool focus) {
          setState(() {});
        },
        child: Listener(
            onPointerDown: (_) {
              FocusScope.of(context).requestFocus(_node);
            },
            child: child));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 130),
      child: Form(
        child: Column(
          children: <Widget>[
            _comboMonto(),
            SizedBox(height: 12),
            _comboPlazo(context),
            SizedBox(height: 12),
            _comboCobro(context),
            SizedBox(height: 12),
            _comboUtilidad(context),
            SizedBox(height: 12),
            _calcContainer(context),
            SizedBox(height: 12),
            _prenda(),
            SizedBox(height: 12),
            Row(
              children: <Widget>[_garante()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _garante() {
    return Expanded(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        trailing: _guarantor != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _guarantor = null;
                  });
                },
                icon: Icon(Icons.delete))
            : null,
        title: Row(
          children: <Widget>[
            Icon(Icons.person, color: Style.secondary),
            SizedBox(width: 10),
            Text(
                _guarantor != null
                    ? "${_guarantor.name}"
                    : "Seleccione Garante",
                style: TextStyle(color: Colors.black54))
          ],
        ),
        subtitle: Row(
          children: <Widget>[
            SizedBox(width: 34),
            Text(_guarantor != null
                ? "Garante: ${_guarantor.phoneA}"
                : "No ha seleccionado"),
          ],
        ),
        onTap: () async {
          var guarantor = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListClientPage(returning: true)));
          if (guarantor != null) {
            setState(() {
              _guarantor = guarantor;
              _credit.guarantorId = _guarantor.id;
            });
          }
        },
      ),
    );
  }

  // Prenda
  Widget _prenda() {
    return expandPanel(
        header: "Prenda",
        iconHeader: FontAwesomeIcons.addressCard,
        child: Column(
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Ingrese detalle de la prenda',
              ),
              onChanged: (v) {
                this._credit.prendaDetail = v;
              },
            ),
            SizedBox(height: 10),
            _showPrenda(context)
          ],
        ));
  }

  Widget _showPrenda(context) {
    if (_credit.filePrenda == null && !_loadPrenda) {
      //? si no esta cargado nada
      return buttonImage(onCamera: () {
        _loadPrendaFunc(source: ImageSource.camera);
      }, onGallery: () {
        _loadPrendaFunc(source: ImageSource.gallery);
      });
    } else if (_credit.filePrenda == null && _loadPrenda) {
      //? Si la imagen esta cargando
      return miniLoader();
    } else {
      //? Si ya esta cargada
      return previewImageLoad(
          tag: "Referencia",
          img: _credit.filePrenda,
          onRemove: () {
            setState(() {
              _credit.filePrenda = null;
            });
          });
    }
  }

  void _loadPrendaFunc({@required ImageSource source}) async {
    setState(() {
      _loadPrenda = true;
    });
    File img = await ImagePicker.pickImage(source: source);
    if (img != null) _credit.filePrenda = await compressImg(img);
    setState(() {
      _loadPrenda = false;
    });
  }
}
