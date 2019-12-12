import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cat300/Home_Page.dart';
import 'package:cat300/auth.dart';
import 'package:cat300/CarOwner/CarOwnerPage.dart';
import 'package:cat300/auth_provider.dart';
import 'package:cat300/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstRoute extends StatefulWidget {


  const FirstRoute({this.onSignedOut});

  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState() {
    return FirstRouteState();

  }

}
class FirstRouteState extends State<FirstRoute> {

  String userid;


  @override
  initstate()
  {


  }
  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut().then((_){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInOne()));
      });


    } catch (e) {
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        theme: ThemeData(
        primaryTextTheme: TextTheme(
        title: TextStyle(color: Colors.black),
    )),home:
      Scaffold(
      appBar: AppBar(
        title: Text('State Change'),
        centerTitle: true, // this is all you need
        actions: <Widget>[

        ],
      ),
      body: Stack(


    children: <Widget>[

     Center(
      child: Image.asset(
        'Assets/gambar.png',
        width: size.width,
        height: size.height,
        fit: BoxFit.fill,
      ),

     ),

      Center(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            ButtonTheme(

              minWidth: 200.0,
              height: 75.0,
              child:
              RaisedButton
                (    color: Colors.white,

                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(45.0),
                    side: BorderSide(color: Colors.red)),

                child: Text('Be a Customer/Student)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            ButtonTheme(

                minWidth: 200.0,
                height: 75.0,
                child:
                RaisedButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(45.0),
                      side: BorderSide(color: Colors.red)),
                  child: Text('Be a Car Owner'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OwnerHome()),
                    );
                  },
                )

            ),

            SizedBox(height: 20),

            ButtonTheme(

                minWidth: 200.0,
                height: 75.0,
                child: RaisedButton(
                  color: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(45.0),
                      side: BorderSide(color: Colors.black)),
                  child: Text('LogOut'),
                  onPressed: () => signOut(context),


                )
            )
            ]
        )
        )

    ]),
    ));
  }
}