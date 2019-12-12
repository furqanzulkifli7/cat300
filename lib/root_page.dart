import 'package:flutter/material.dart';
import 'package:cat300/auth.dart';
import 'package:cat300/Home_Page.dart';
import 'package:cat300/login_page.dart';
import 'package:cat300/auth_provider.dart';

import 'ChangeState.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((String userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return SignInOne(
          onSignedIn: _signedIn,
        );
        case AuthStatus.notSignedIn:
        return SignInOne(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return FirstRoute(
          onSignedOut: _signedOut,
        );
    }
    return null;
  }



}