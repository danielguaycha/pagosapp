import 'package:flutter/material.dart';
import 'package:pagosapp/src/models/responser.dart';
import 'package:pagosapp/src/plugins/style.dart';
import 'package:pagosapp/src/providers/auth_provider.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authProvider = AuthProvider();
  final _formKey = GlobalKey<FormState>();

  bool _loader = false;
  final _focusPw = FocusNode();
  bool _passwordVisible;

  String _msg = '';
  String _password = '';
  String _user = '';

  @override
  void initState() {
    this._passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  Widget _form() {
    return Center(
      child: SingleChildScrollView(        
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _logo(),
              SizedBox(height: 25),
              _errMessage(),
              _userInput(),
              SizedBox(height: 20.0),
              _pwInput(),
               SizedBox(height: 35.0),
               _btnLogin(context)
            ],
          ),
        ),
      ),
    );
  }

  void _submitLogin(context) async {
    setState(() {
      // reset Params
      _loader = true;
      _msg = '';
    });

    print("$_user $_password");

    Responser res = await _authProvider.login(_user, _password);
    if (!res.ok) {
      setState(() {
        _msg = res.message;
      });
    }

    if(res.data != null && res.data['access_token']!=null) {
      Navigator.pushReplacementNamed(context, 'home');
    }

    setState(() {
      _loader = false;
    });
  }

  // Componentes del formulario
  Widget _logo () => SizedBox(
    height: 110.0,
    child: Image.asset(
      "assets/payicon.png",
      fit: BoxFit.contain,
    ),
  );

  Widget _userInput() {
    return TextFormField(
      initialValue: _user,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v){ FocusScope.of(context).requestFocus(_focusPw);},
      decoration: InputDecoration(
        hintText: "Nombre de usuario",
        suffixIcon: Icon(Icons.person),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
      onSaved: (value) => _user = value,
      validator: (value) {
        if (value.trim() == '') {
          return 'Ingrese su nombre de usuario';
        }

        if (value.length < 3) {
          return 'Ingrese un nombre de usuario válido';
        }
        return null;
      },
    );
  }

  Widget _pwInput() {
    return TextFormField(      
      obscureText: !_passwordVisible,
      focusNode: _focusPw,
      initialValue: '',
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        hintText: "Contraseña",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
              _passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
              color: Theme.of(context).primaryColor,
              ),
          onPressed: () {            
              setState(() {
                  _passwordVisible = !_passwordVisible;
              });
            },
        ),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
      onSaved: (value) =>  _password = value,
      onFieldSubmitted: (v) {
          if (!_formKey.currentState.validate()) return;
          _formKey.currentState.save();          
          FocusScope.of(context).requestFocus(FocusNode());
          _submitLogin(context);
      },
      validator: (value) {
        if (value.trim() == '') {
          return 'Ingrese su contraseña';
        }
        return null;
      },
    );
  }

  Widget _btnLogin(BuildContext context) {
    return FlatButton(
        disabledColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: _loader
            ? null
            : () {
                if (!_formKey.currentState.validate()) return;
                _formKey.currentState.save();
                _submitLogin(context);
                //Navigator.of(context).pushNamed(.tag);
              },
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        color: Theme.of(context).primaryColor,
        child: textOrLoader(
            context,
            loader: _loader,
            loaderText: "INICIANDO...",
            text: "INICIAR SESIÓN"),
      );
  }

  //others widgets
  Widget textOrLoader(context, {bool loader: false, String loaderText: 'Procesando...', String text: 'Button'}) {
    if(loader) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
              strokeWidth: 2.0,      
              valueColor: AlwaysStoppedAnimation<Color>(Style.primary[300]),
            ),
          ),        
          SizedBox(width: 10),
          Text(loaderText, style: TextStyle(
            color: Style.primary[300],
            fontSize: Theme.of(context).textTheme.button.fontSize),),        
        ],
      );
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  Widget _errMessage() {
    bool _show = false;
    
    if(_msg != null && _msg.isNotEmpty)
      _show = true;

    return Visibility(
        visible: _show,
        child: Container(         
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          decoration: new BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Row(           
            children: <Widget>[      
              Container(
                child: Icon(Icons.error, color: Colors.white),
                margin: EdgeInsets.only(right: 7),          
              ),
              
              Expanded(          
                child: Text("$_msg", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)), 
              ),          
          ]
        )
      ),
    );
  }
}