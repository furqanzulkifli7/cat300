
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fluttertoast/fluttertoast.dart';

class RegisteredCar extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return RegisteredCarState();

  }


}


class RegisteredCarState extends State<RegisteredCar> {
  final databaseReference = Firestore.instance;

  Future data;
  Future dat;
  String uid=" ";
  String carName=" ";
  String carPlate=" ";
  String carRate=" ";
  String carBrand=" ";
  String year=" ";



  void initState()
  {
    super.initState();

    data = getposts();

    getposts();

  }


  navigateToDetail(DocumentSnapshot post)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailCar(post: post,)));

  }

  Future getposts() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();


    var firestore= Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Registered Car').where("uid",isEqualTo: uid).getDocuments();

    return qn.documents;

  }




  @override
  Widget build(BuildContext context) {


    return new Container

      (child:
    FutureBuilder
      (
        future: data,

        builder: (_, snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
          {

            return Center(

              child: Text('Loading ..'),
            );
          }
          else
          {


            return ListView.builder(
                itemCount: snapshot.data.length,
                itemExtent: 100.0,

                itemBuilder:(_, index) {


                  return ListTile(

                    leading: CircleAvatar(
                      radius: 50.0,
                      child: ClipOval(
                        child: Image.network(
                          (snapshot.data[index].data["Car Photo"]),
                          width: 200,
                          height: 400,
                          fit: BoxFit.fill,
                        ),
                      ),


                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),

                    title: Text(
                        carName = snapshot.data[index].data["Car Name"],style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                    subtitle: Text("Year Of Manufactured : " +
                        snapshot.data[index].data["Car Manufacturing Year"],style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),),

                    onTap:() =>navigateToDetail(snapshot.data[index]),

                  )
                  ;


                }

                  );
          }
        }
    ),



      decoration: new BoxDecoration(
          image: DecorationImage(
            image: AssetImage("Assets/Backgroundowner.png"),
            fit: BoxFit.fill,
          ),
          gradient: new LinearGradient(colors: [
            const Color(0xFFFFFFFF),
            const Color(0xFFDCEDC8),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),

    );

  }
}

class DetailCar extends StatefulWidget{
  final DocumentSnapshot post;

  DetailCar({


    this.post


  });
  @override
  State<StatefulWidget> createState() {
    return DetailCarState();

  }

}

class DetailCarState extends State<DetailCar> {

  String bookingID = " ";
  DateTime _dateTime;
  DateTime timer;
  double rental = 0.00;
  String owner = " ";
  String phone = " ";

  var formattedDate = " ";
  var _time = "Not set";


  var returntime = " ";
  var returndate = " ";

  int rent = 0;

  String datebook = " ";
  int _currentPrice = 1;
  bool isLoading = false;

  String photoUrl = '';

  String carid=" ";







  Future <void> getdetail() async
  {
    Firestore.instance.collection('Student').where(
        "uid", isEqualTo: widget.post.data["uid"]).snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => owner = doc["Name"],));


    Firestore.instance.collection('Student').where(
        "uid", isEqualTo: widget.post.data["uid"]).snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => phone = doc["Mobile Phone"],));

 carid=widget.post.data["Register Car UID"];

    setState(() {});
  }


  @override
  void initState() {
    getdetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Car Information"),
          centerTitle: true,
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(
                        children: [ CircleAvatar(
                          child: Image.network((widget.post.data["Car Photo"]),

                            fit: BoxFit.contain,

                          ),
                          backgroundColor: Colors.transparent,
                          radius: 150.0,

                        ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 1.2,

                            decoration: new BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black45,
                                      blurRadius: 2.0,
                                      offset: new Offset(0.0, 2.0))
                                ]),

                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>
                                [

                                  Icon(
                                    Icons.directions_car,
                                    color: const Color(4292030255),
                                    size: 36.0,
                                  ),
                                  Text("  "),
                                  Text(widget.post
                                      .data["Car Name"]

                                    , style: new TextStyle(
                                        fontSize: 23.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),),


                                ]
                            ),

                          ),

                          new Align(
                              alignment: Alignment.center,
                              child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: _height / 40),

                                  child: Column(

                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width / 1.2,
                                          decoration: new BoxDecoration(

                                              boxShadow: [
                                                new BoxShadow(
                                                    color: Colors.black45,
                                                    blurRadius: 2.0,
                                                    offset: new Offset(
                                                        0.0, 2.0))
                                              ]
                                              ,
                                              gradient: new LinearGradient(
                                                  colors: [
                                                    const Color(4294954172),
                                                    const Color(452984831),
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)
                                          ),

                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: <Widget>
                                              [


                                                infoChild(_width,
                                                    Icons.bookmark_border,
                                                    "Car Brand   : ", widget.post
                                                        .data["Car Brand"]),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(_width, Icons.person,
                                                    "Car Manufacturing Year : ", widget.post.data["Car Manufacturing Year"]),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.keyboard_arrow_right,
                                                    "Car Plate   : ", widget.post.data["Car Plate"]),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.event_seat,
                                                    "Number Of Seat   : ",
                                                    widget.post.data["Seat"]),


                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.attach_money,
                                                    "Car Rate (Per Hour)   : ",
                                                    widget.post
                                                        .data["Car Rate"]),


                                                SizedBox(
                                                  height: 10,
                                                ),


                                              ]

                                          ),

                                        ),
                                        Padding(padding: new EdgeInsets.only(
                                            top: _height / 40)),

                              Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 1.2,
                                  decoration: new BoxDecoration(

                                      boxShadow: [
                                        new BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2.0,
                                            offset: new Offset(
                                                0.0, 2.0))
                                      ]
                                      ,
                                      gradient: new LinearGradient(
                                          colors: [
                                            const Color(4294954172),
                                            const Color(452984831),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)
                                  ),



                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly
                                    ,
                                    children: <Widget>
                                    [

                                      RaisedButton(
                                          child: Text("Delete Registered Car"),
                                          onPressed:  () {
                                            showAlertDialog(context);
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                      ),

                                      RaisedButton(
                                          child: Text("Refresh"),
                                          onPressed: getdetail,
                                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                      )
                                      ,



                                    ]

                                ),


                              )
                                      ])


                              ))
                        ]


                    )
                )
            )));
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget remindButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {

        print(carid);

        Firestore.instance.collection("Registered Car").document(carid)
            .delete();
        Navigator.of(context, rootNavigator: true).pop('dialog');

        Navigator.of(context).pop(); // dismiss dialog

        Fluttertoast.showToast(
            msg: "Car Information Deleted",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 20
        );
      },
    );

    Widget launchButton = FlatButton(
        child: Text("No"),
        onPressed:  () {


          Navigator.of(context, rootNavigator: true).pop('dialog');


        });


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booking Detail Cancellation"),
      content: Text("Delete all Booking Detail?"),
      actions: [
        remindButton,

        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget infoChild(double width, IconData icon, data2, data) =>
      new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[

              new Icon(
                icon,
                color: Colors.redAccent,
                size: 30.0,
              ),
              new SizedBox(
                width: width / 30,
              ),
              new Text(data2,
                style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),),

              new Text(data, style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),)
            ],

          ),
          onTap: () {
            getdetail();
            print(carid);
          },
        ),
      );
}