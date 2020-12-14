import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pagosapp/src/models/client.dart';
import 'package:pagosapp/src/models/client/client_history.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/pages/credit/add_credit_page.dart';
import 'package:pagosapp/src/plugins/file_manager.dart';
import 'package:pagosapp/src/plugins/messages.dart';
import 'package:pagosapp/src/plugins/perms.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/providers/client_provider.dart';
import 'package:pagosapp/src/utils/exepctions.dart';
import 'package:pagosapp/src/utils/utils.dart';

class EditClientPage extends StatefulWidget {
  final int clientId;
  final int status;
  EditClientPage({Key key, @required this.clientId, @required this.status}) : super(key: key);

  @override
  _EditClientPageState createState() => _EditClientPageState();
}

class _EditClientPageState extends State<EditClientPage> {
  bool _loadRefOne = false;
  bool _loadRefTwo = false;
  bool _geoloc = false;
  bool _geolocB = false;
  Client _client;
  //ContactManager _cm;

  bool _loader;
  String _error;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<String>> _key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> _key2 = new GlobalKey();

  final List<String> _cities = [
    'Machala',
    'Manta',
    'Huaquillas',
    'El Guabo',
    'Sta. Rosa',
    'Pasaje',
    'El Cambio'
  ];

  @override
  void initState() {
    this._client = new Client();
    //this._cm = new ContactManager();
    _loader = false;
    _loadClientData(idClient: widget.clientId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _loader = new ProgressLoader(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Editar cliente"),
        centerTitle: true,
      ),
      body: _waitData(),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {_submitUpdate(context);},
        child: Icon(FontAwesomeIcons.upload, color: Style.primary[800],)
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 70),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                  initialValue: _client.name,
                  onSaved: (v) {
                    this._client.name = v;
                  },
                  validator: (v) {
                    if (v.trim() == '') {
                      return 'Ingrese su nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefono Personal',
                  ),
                  initialValue: _client.phoneA,
                  onSaved: (v) {
                    this._client.phoneA = v;
                  },
                  onChanged: (v) {
                    this._client.phoneA = v;
                  },
                  validator: (v) {
                    if (_client.phoneA == null && _client.phoneB == null) {
                      return "Ingrese al menos un teléfono personal";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Telefono Trabajo',
                  ),
                  initialValue: _client.phoneB,
                  onSaved: (v) {
                    this._client.phoneB = v;
                  },
                  onChanged: (v) {
                    this._client.phoneB = v;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Facebook',
                  ),
                  initialValue: _client.fb,
                  onSaved: (v) {
                    this._client.fb = v;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                expandPanel(
                    header: "Dirección de domicilio",
                    iconHeader: FontAwesomeIcons.addressBook,
                    child: Column(
                      children: <Widget>[
                        _comboCityA(),
                        SizedBox(height: 15),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Ingrese dirección de domicilio',
                          ),
                          initialValue: _client.addressA,
                          onSaved: (v) {
                            this._client.addressA = v;
                          },
                          onChanged: (v) {
                            this._client.addressA = v;
                          },
                          validator: (v) {
                            if (_client.addressA == null &&
                                _client.addressB == null) {
                              return "Ingrese una dirección";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        _switchGeoLoc(),
                        SizedBox(height: 15),
                        _showReferenceOne(context),
                      ],
                    )),
                Divider(),
                expandPanel(
                    header: "Dirección Trabajo",
                    iconHeader: FontAwesomeIcons.addressCard,
                    child: Column(
                      children: <Widget>[
                        _comboCityB(),
                        SizedBox(height: 10),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Ingrese dirección de trabajo',
                          ),
                          initialValue: _client.addressB,
                          onSaved: (v) {
                            this._client.addressB = v;
                          },
                        ),
                        SizedBox(height: 10),
                        _showReferenceTwo(context),
                        SizedBox(height: 10),
                        _switchGeoLocB()
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  //* Wigets
  Widget _waitData() {
    if (_loader) {
      return loader(text: "Cargando cliente...");
    }

    if (_error != null) {
      return renderError(_error, () {});
    }

    if (_client == null) {
      return renderNotFoundData("No hay coincidencias para mostrar");
    }

    return _body();
  }

  Widget _showReferenceOne(context) {    
    // _client.refOne = null;
    if (_client.refOne == null && _client.refA == null && !_loadRefOne) {
      //? si no esta cargado nada
      return buttonImage(onCamera: () {
        _loadReferenceOne(source: ImageSource.camera);
      }, onGallery: () {
        _loadReferenceOne(source: ImageSource.gallery);
      });
    } else if (_client.refOne == null && _loadRefOne) {
      //? Si la imagen esta cargando
      return miniLoader();
    } else {
      //? Si ya esta cargada
      if(_client.refA == null) {
        return previewImageLoad(
          tag: "Referencia",
          img: _client.refOne,
          onRemove: () {
            setState(() {
              _client.refOne = null;
            });
          });
      } 
      else {
        return previewImageNet(
          tag: 'Referencia actual',
          url: _client.refA,
          onRemove: () {
            setState(() {
              _client.refA = null;
            });
          }
        );
      }      
    }
  }

  Widget _showReferenceTwo(context) {
    if (_client.refTwo == null && !_loadRefTwo && _client.refB == null) {
      //? si no esta cargado nada
      return buttonImage(onCamera: () {
        _loadReferenceTwo(source: ImageSource.camera);
      }, onGallery: () {
        _loadReferenceTwo(source: ImageSource.gallery);
      });
    } else if (_client.refTwo == null && _loadRefTwo) {
      //? Si la imagen esta cargando
      return miniLoader();
    } else {
      //? Si ya esta cargada
      if(_client.refB == null) {
        return previewImageLoad(
            tag: "Referencia",
            img: _client.refTwo,
            onRemove: () {
              setState(() {
                _client.refTwo = null;
              });
            });
      }
      else
        return previewImageNet(
          tag: 'Referencia actual',
          url: _client.refB,
          onRemove: () {
            setState(() {
              _client.refB = null;
            });
          }
        );    
    }
  }

  Widget _switchGeoLoc() {
    return SwitchListTile(
      value: _geoloc,
      contentPadding: EdgeInsets.symmetric(vertical: 2),
      title: swicthTitle(
          title: "Usar la ubicación del domicilio",
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geoloc),
      subtitle: swicthSubtitle(text: "¿En esta ubicación se harán los cobros?"),
      onChanged: (value) async{
        if(!await locationPerms()) {
          _geoloc = false;
        } else _geoloc = value;
        setState(() { });
      },
    );
  }

  Widget _switchGeoLocB() {
    return SwitchListTile(
      value: _geolocB,
      contentPadding: EdgeInsets.symmetric(vertical: 2),
      title: swicthTitle(
          title: "Usar ubicación del Trabajo",
          icon: FontAwesomeIcons.mapMarkerAlt,
          swicthed: _geolocB),
      subtitle: swicthSubtitle(text: "¿En esta ubicación se harán los cobros?"),
      onChanged: (value) async {
        if(!await locationPerms()) {
          _geolocB = false;
        } else {        
          _geolocB = value;      
        }
        setState(() {});
      },
    );
  }

  //* Combo ciudad de domicilio
  Widget _comboCityA() {
    return AutoCompleteTextField<String>(
      key: _key,
      controller: TextEditingController(text: _client.cityA),
      decoration: InputDecoration(
        labelText: "Ciudad de docimicilio",
      ),
      suggestions: _cities,
      clearOnSubmit: false,
      suggestionsAmount: 3,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
            title: new Text(suggestion),
          ),
          padding: EdgeInsets.all(4.0)),
      itemSubmitted: (text) {
        setState(() {
          _client.cityA = text;
        });
      },
      itemFilter: (suggestion, input) =>
          suggestion.toLowerCase().startsWith(input.toLowerCase()),
      itemSorter: (String a, String b) {
        return -1;
      },
    );
  }

  Widget _comboCityB() {
    return AutoCompleteTextField<String>(
      key: _key2,
      controller: TextEditingController(text: _client.cityB),
      decoration: InputDecoration(
        labelText: "Ciudad de trabajo",
      ),
      suggestions: _cities,
      clearOnSubmit: false,
      suggestionsAmount: 3,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
            title: new Text(suggestion),
          ),
          padding: EdgeInsets.all(4.0)),
      itemSubmitted: (text) {
        setState(() {
          _client.cityB = text;
        });
      },
      itemFilter: (suggestion, input) =>
          suggestion.toLowerCase().startsWith(input.toLowerCase()),
      itemSorter: (String a, String b) {
        return -1;
      },
    );
  }

  //* Funciones
  // Referencias
  void _loadReferenceOne({@required ImageSource source}) async {
    setState(() {
      _loadRefOne = true;
    });
    File img = await ImagePicker.pickImage(source: source);
    if (img != null) _client.refOne = await compressImg(img);
    setState(() {
      _loadRefOne = false;
    });
  }

  void _loadReferenceTwo({@required ImageSource source}) async {
    setState(() {
      _loadRefTwo = true;
    });
    File img = await ImagePicker.pickImage(source: source);
    if (img != null) _client.refTwo = await compressImg(img);
    setState(() {
      _loadRefTwo = false;
    });
  }

  void _loadClientData({search: false, int idClient}) async {
    setState(() {
      _loader = true;
    });
    Responser res;
    res = await ClientProvider().showClient(idClient);

    if (res.ok) {
      var results = res.data;
      _client = Client.fromJson(json.encode(results));      
    } else {
      _error = res.message;
    }
    _loader = false;
    setState(() {});
  }

  void _submitUpdate(context) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();    

    if(!await confirm(context, title: "¿Desea actualizar?", content: "Esta seguro de cambiar los datos de este cliente")){
      return;
    }
    //TODO: Modificar el contacto queda pendiente aqui
    if (_geoloc || _geolocB) {
      final loc = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (_geoloc) {
        _client.latA = loc.latitude;
        _client.lngA = loc.longitude;
      }
      if (_geolocB) {
        _client.latB = loc.latitude;
        _client.lngB = loc.longitude;
      }
    }

    Responser res;
    res = await ClientProvider().upDateClient(_client);
    if (res.ok) {
      toast('Datos actualizados', type: 'ok');
      _openCredit();
    } else {    
      _error = res.message;
      toast('Algo salio mal | $_error', type: 'err');
    }
  }

  void _openCredit() {
    if(_client.activeCredit) { // si tiene un crédito activo solo actualiza los datos
      return;
    }
    ClientHistory clientHistory = new ClientHistory();
    clientHistory.name = _client.name;
    clientHistory.id = _client.id;    
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => AddCreditPage(
        clientHistory: clientHistory,
    )));
  }
}
