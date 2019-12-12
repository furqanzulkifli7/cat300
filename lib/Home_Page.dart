import 'package:flutter/material.dart';
import 'package:cat300/auth.dart';
import 'package:cat300/auth_provider.dart';
import 'package:cat300/FrontPage/BookList.dart';
import 'package:cat300/FrontPage/Profile.dart';
import 'package:cat300/FrontPage/Search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomePage extends StatefulWidget {


  const HomePage({this.onSignedOut});

  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState() {
    return HomePageState();

  }

}


class HomePageState extends State<HomePage> {

  DocumentSnapshot snapshot;

  String name=' ';
  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();

      widget.onSignedOut();
    } catch (e) {
      print(e);
    }

  }


  int _selectedTab = 0;
  final _pageOptions = [
    Profile(),
    BookList(),
    Search(),


  ];




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.red,
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.white),
          )),
      home: Scaffold(
      appBar: AppBar(
        title: Text('Student Account', textAlign: TextAlign.center,),
        centerTitle: true, // this is all you need

        actions: <Widget>[
          FlatButton(

            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => signOut(context),
          )
        ],
      ),
      body:
      _pageOptions[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: Colors.redAccent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,        currentIndex: _selectedTab,
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 20,),
            title: Text('Profile Page',style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_outline,size: 20,),
            title: Text('Booking Made',style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,size: 20,),
            title: Text('List Of Car',style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400),),
          ),
        ],
      ),
    ));


  }
}