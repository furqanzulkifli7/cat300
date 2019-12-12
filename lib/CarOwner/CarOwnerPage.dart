import 'package:flutter/material.dart';
import 'package:cat300/auth.dart';
import 'package:cat300/auth_provider.dart';
import 'package:cat300/CarOwner/Booking.dart';
import 'package:cat300/CarOwner/Profile.dart';
import 'package:cat300/CarOwner/ListOfCar.dart';
import 'package:cat300/CarOwner/RegisterCar.dart';

import 'package:cat300/textWidgets.dart';



class OwnerHome extends StatefulWidget {


  const OwnerHome({this.onSignedOut});

  final VoidCallback onSignedOut;


  @override
  State<StatefulWidget> createState() {
    return OwnerHomeState();

  }

}



class OwnerHomeState extends State<OwnerHome> {




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

    OwnerProfile(),
    Register(),
    BookList(),
    RegisteredCar(),



  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.teal,
            primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black),
            )),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Car Owner Account', textAlign: TextAlign.center,),
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

            backgroundColor: Colors.red,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.blue,        currentIndex: _selectedTab,
            onTap: (int index) {
              setState(() {
                _selectedTab = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile Page'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('Add Car'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                title: Text('Booking Made'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_car),
                title: Text('Registered Car'),
              ),
            ],
          ),
        ));


  }
}