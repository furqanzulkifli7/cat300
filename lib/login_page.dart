import 'package:cat300/Models/appConstants.dart' as prefix0;
import 'package:cat300/SignUpPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cat300/Models/appConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cat300/ChangeState.dart';
import 'package:cat300/Models/userObjects.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class SignInOne extends StatefulWidget {

  const SignInOne({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _SignInOneState();
}

enum FormType {
  login,
  register,
}

class _SignInOneState extends State<SignInOne> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode _focusNode = new FocusNode();

  String _email;
  String _password;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FormType _formType = FormType.login;

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {


    if (formKey.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).whenComplete(()=>
          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 20
          ),

      ).then((firebaseUser) {
        Navigator.push(context,MaterialPageRoute(builder: (context) => FirstRoute()));
              

         });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,

        appBar: AppBar(
          centerTitle: true,
        title: Text('Login Page'),
      ),
      body:

          SingleChildScrollView(
      child: Stack(
          children: <Widget>[

      Container(
        decoration: BoxDecoration(






        ),

        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,


        margin: EdgeInsets.only(top: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: intro()+buildInputs() + buildSubmitButtons()+signUp(),
          ),
        ),
      ),
    ])
          ));
  }

  List<Widget> signUp() {
    return <Widget>[


    Center(

    child: SizedBox(
        width: double.infinity, // match_parent

    child: RaisedButton(
      color: Colors.red,
      textColor: Colors.white,

    child: Text('New in here? Create an account!', style: TextStyle(fontSize: 20.0))
      ,

    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignUpPage()),
    );
    },)
    ),
    )
    ];



  }
  List<Widget> intro()
  {
    return <Widget>[

  Image.asset((
  'Assets/image1.png'
  )),
    new Text(
      "Rent Car With Us Now",

      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'SFUIDisplay',
          fontSize: 30

      ),

    )];

  }

  List<Widget> buildInputs() {
    return <Widget>[
      SizedBox(height: 20),

      TextFormField(

        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(

          ),

        ),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
        controller: _emailController,


      ),

      SizedBox(height: 8.0),
      TextFormField(

        key: Key('password'),
        decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock_outline),
        labelStyle: TextStyle(
            fontSize: 15
        ),

      ),

        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
        controller: _passwordController,

      ),
      SizedBox(height: 5),

    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RaisedButton(

          color: Colors.blue,
          textColor: Colors.white,
          key: Key('signIn'),
          child: Text('Login', style: TextStyle(fontSize: 20.0)),

          onPressed: validateAndSubmit,
        ),

      ];
    } else {
      return <Widget>[
        RaisedButton(

          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
          onPressed: (){}
        ),
      ];
    }
  }
}