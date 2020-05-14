import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagosapp/src/pages/client/new_client_page.dart';
import 'package:pagosapp/src/pages/credit/partial/credit_client_component.dart';

class NewCreditPage extends StatefulWidget {
  NewCreditPage({Key key}) : super(key: key);

  @override
  _NewCreditPageState createState() => _NewCreditPageState();
}

class _NewCreditPageState extends State<NewCreditPage> {
  int _currentStep = 0;
  bool _completeStep = false;
  List<Step> spr = <Step>[];
  List<bool> _stepError = [false, false];
  final _scaffoldKey = GlobalKey<ScaffoldState>();    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Agregar Crédito'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Stepper(
            steps: _getSteps(context),
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (step) {                
              _markState(step);
              _goTo(step);
            },              
            controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Row(children: <Widget>[Container(child: null,), Container(child: null,),],);
            },
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only( bottom: 10.0, right: 0),
          child: _floatings(context),
      )
    );
  }

  Widget _floatings(context) {
    if (_currentStep == 0) {
      return _floatingForClient(context);
    }
    else if (_currentStep == 1) {
      return Center();
    }
    else {
      return Center();
    }

  }

  List<Step> _getSteps(BuildContext context) {
    spr = <Step>[
      Step(
          title: const Text('Cliente'),
          content: CreditClientComponent(),
          state: _getState(0),
          isActive: _currentStep >= 0  ),
      Step(
          title: const Text('Credito'),
          content: Text("Steep2"),
          state: _getState(1),
          isActive: _currentStep >= 1),     
    ];
    return spr;
  }

  StepState _getState(int i) {
    if(_currentStep == i)
      return StepState.editing;
    if (_currentStep >= i){
      if(_stepError[i] == true) {
        return StepState.error;
      }
      return StepState.complete;
    }      
    else
      return StepState.indexed;
  }

  Widget _floatingForClient(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _minBtn(
            tooltip: "Agregar cliente",
            icon: FontAwesomeIcons.userPlus,
            onPressed: () async {
              /* var client = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddClientPage()));
              if(client != null)
                _setClient(client); */
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NewClientPage()));
            }
        ),
        SizedBox(height: 15),
        FloatingActionButton(
          onPressed: () async {
           /*  if (_client == null) {
              var client = await showSearch(context: context, delegate: SearchClientDelegate());              
              if(client!=null)
                _setClient(client);
            }
            else{
              _markState(_currentStep+1);
              next();
            } */
          },
          tooltip: 'Buscar cliente',
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Icon( Icons.search),
        )
      ],
    );
  }

  Widget _minBtn({IconData icon: FontAwesomeIcons.arrowLeft, @required Function onPressed, String tooltip: '' }) {
    return Tooltip(
      message: tooltip,
      child: RawMaterialButton(
        onPressed: onPressed,
        child: new Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 17.0,        
        ),  
        shape: new CircleBorder(),
        constraints: BoxConstraints(minHeight: 35, minWidth: 35),
        elevation: 7,
        fillColor: Colors.grey[300],
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }

  _markState(step) {
    /* if(step >= 1 && _client == null) {
      _stepError[0] = true;                  
    } else {
      _stepError[0] = false;
    } */

   /*  if(step == 2 && _credit.monto == null || _credit.plazo == null || _credit.utilidad == null || _credit.cobro == null || _credit.monto <= 0) {                  
      _stepError[1] = true;
    } else {
      _stepError[1] = false;
    } */
  }

  _next() {
    _currentStep + 1 != spr.length
        ? _goTo(_currentStep + 1)
        : setState(() => _completeStep = true);
  }
  
  _cancel() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
    }
  }
  
  _goTo(int step) {
    setState(() => _currentStep = step);
  }
}