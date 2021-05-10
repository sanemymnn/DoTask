import 'package:flutter/material.dart';
import 'package:do_task/models/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:do_task/widgets/provider_widget.dart';
import 'TodayScreen.dart';

// TODO move this to tone location

enum AuthFormType { signIn, signUp }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;
  static const route = "/signupview";

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;

  _SignUpViewState({this.authFormType});
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _surname, _error;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Signed In with ID $uid");
          Navigator.of(context).pushReplacementNamed(TodayScreen.route);
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
            _name, _surname, _email, _password);
          print("Signed up with New ID $uid");
          Navigator.of(context).pushReplacementNamed(TodayScreen.route);
        }
      } catch (e) {
        print(e);
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        height: _height,
        width: _width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: _height * 0.025),
              showAlert(),
              SizedBox(height: _height * 0.1),
              buildHeaderText(),
              SizedBox(height: _height * 0.02),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "Create New Account";
    } else {
      _headerText = "Sign In";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 33,
        color: Colors.black,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    // if were in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 18.0),
          decoration: InputDecoration(
          border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8)
    ),
          labelText: "Name",
          
          ),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
      textFields.add(
        TextFormField(
          
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 18.0),
          decoration: InputDecoration(
          border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8)
    ),
          labelText: "Surname",
          
          ),
          onSaved: (value) => _surname = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 18.0),
        
        decoration: InputDecoration(
          border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8)
    ),
          labelText: "Email",
          
          ),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 18.0),
        decoration: InputDecoration(
          border: new OutlineInputBorder(
      borderSide: new BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8)
    ),
          labelText: "Password",
          suffixIcon:FlatButton(child: _obscureText ? Icon(Icons.visibility_off) : Icon(Icons.visibility) , onPressed: _toggle,
          ), 
          ),
      obscureText: _obscureText,
        
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.blue,
      
      enabledBorder: OutlineInputBorder(
        
        borderRadius: BorderRadius.circular(29),
          borderSide: BorderSide(color: Colors.blue, width: 0.0)
          ),
      contentPadding:
      
          const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "SUBMIT";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "SUBMIT";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          child: Text(_submitButtonText),
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
              
              side: BorderSide(color: Colors.blue)),
          color: Colors.blue,
          textColor: Colors.black,
          
          onPressed: submit,
        ),
      ),
      SizedBox(height: 20),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }
}
