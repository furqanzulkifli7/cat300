
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_rating/flutter_rating.dart';

class BookList extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return BookListState();

  }

}
String uid;

class BookListState extends State<BookList> {
  final databaseReference = Firestore.instance;

  Future data;
  Future dat;
  String uid=" ";
  String carName=" ";
  String carPlate=" ";
  String carRate=" ";
  String carBrand=" ";
  String year=" ";

  int item;

  void initState()
  {
    super.initState();

    data = getposts();

  }


  navigateToDetail(DocumentSnapshot post)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> BookListDetail(post: post,)));

  }

  Future getposts() async{

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    var firestore= Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Booking').where("Customer ID",isEqualTo: uid).getDocuments();

    return qn.documents;

  }




  @override
  Widget build(BuildContext context) {


    return new Container

      (


      decoration: new BoxDecoration(

        image: DecorationImage(
          image: AssetImage("Assets/background.jpg"),
          fit: BoxFit.fill,
        ),
          gradient: new LinearGradient(colors: [
            const Color(4294954172),
            const Color(452984831),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
      ),
      child:
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

                itemBuilder:(_, index){

                  return ListTile(

                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(

                          border: new Border(
                              left
                                  : new BorderSide(width: 10.0, color: Colors.white)

                          )

                      ),
                      child: Icon(Icons.subdirectory_arrow_right, color: Colors.white),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right,color: Colors.white, size: 20,),


                    title: Text(snapshot.data[index].data["Starting Date"]??"No Booking is Made",style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),),
                    subtitle: Text("Duration Of Rent : "+snapshot.data[index].data["Duration"].toString()+" Hours",style: new TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),),
                    onTap:() =>navigateToDetail(snapshot.data[index]),

                  )

                  ;
                });
          }
        }
    ),




    );

  }

}

class BookListDetail extends StatefulWidget{
  final DocumentSnapshot post;
  BookListDetail({


    this.post


  });

  @override
  State<StatefulWidget> createState() {
    return BookListDetailState();

  }


}

class BookListDetailState extends State<BookListDetail> {


  String photoURl = " ";

  String carName = " ";

  String carBrand = " ";
  String ownerName = " ";
  String owneruid=" ";
  String ownerphone=" ";

  String bookingid=" ";
  double rating = 0.5;
  int starCount = 5;


  Future <void> getdetail() async
  {

    Firestore.instance.collection('Registered Car').where(
        "Register Car UID", isEqualTo: widget.post.data["Booking Car ID"])
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => photoURl = doc["Car Photo"],));

    Firestore.instance.collection('Registered Car').where(
        "Register Car UID", isEqualTo: widget.post.data["Booking Car ID"])
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => carName = doc["Car Name"],));
    Firestore.instance.collection('Registered Car').where(
        "Register Car UID", isEqualTo: widget.post.data["Booking Car ID"])
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => carBrand = doc["Car Brand"],));

    Firestore.instance.collection('Registered Car').where(
        "Register Car UID", isEqualTo: widget.post.data["Booking Car ID"])
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => owneruid = doc["uid"],));

    Firestore.instance.collection('Student').where(
        "uid", isEqualTo: owneruid)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => ownerName = doc["Name"],));

    Firestore.instance.collection('Student').where(
        "uid", isEqualTo: owneruid)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => ownerphone = doc["Mobile Phone"],));


    bookingid=widget.post.data["Booking ID"];
print(bookingid);

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
          title: Text("Booking Detail"),
          centerTitle: true,
        ),
        body: Container(

            child: SingleChildScrollView(
                child: Center(
                    child: Column(
                        children: [ CircleAvatar(
                          child: Image.network((photoURl),

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
                                  Text(carName

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
                                                infoChild(_width, Icons.person,
                                                    "Owner Name  : ", ownerName),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.phone_android,
                                                    "Phone Number   : ", ownerphone),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.calendar_today,
                                                    "Booking Date   : ", widget.post.data["Starting Date"]),


                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.timer,
                                                    "Car Pickup at  : ", widget.post.data["Starting Time"]),


                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.date_range,
                                                    "Date Ended  : ", widget.post.data["Ending Date"]),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.timer_off,
                                                    "Return Car at  : ", widget.post.data["Ending Time"]),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.timer,
                                                    "Duration of rent : ", widget.post.data["Duration"].toString()+" Hours"),


                                                SizedBox(
                                                  height: 10,
                                                ),
                                                infoChild(
                                                    _width, Icons.attach_money,
                                                    "Total Rental RM", widget.post.data["Total Rent"].toString()),


                                              ]

                                          ),


                                        ),


 Column(
    children: <Widget>[

      StarRating(
        size: 40.0,
        rating: rating,
        color: Colors.orange,
        borderColor: Colors.grey,
        starCount: starCount,
        onRatingChanged: (rating) => setState(
              () {
            this.rating = rating;
          },
        ),
      ),
      new Text(
        "Rating of car: $rating",
        style: new TextStyle(fontSize: 30.0),
      ),

      Padding(padding: new EdgeInsets.only(top: _height / 100)),

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
                                                .spaceEvenly,
                                            children: <Widget>
                                            [

                                              RaisedButton(
                                                  child: Text("Rate"),
                                                  onPressed: getdetail,
                                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                              )
,
                                              RaisedButton(
                                                  child: Text("Delete Booking"),
                                                  onPressed:  () {
                                                    showAlertDialog(context);
                                                  },
                                                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                              )


                                            ]

)
)
    ]
                                  )

                             ] ))
                          )]
                    )
                )
            )
        ));



  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget remindButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {

print(bookingid);

     Firestore.instance.collection("Booking").document(bookingid)
    .delete();
Navigator.of(context, rootNavigator: true).pop('dialog');

Navigator.of(context).pop(); // dismiss dialog

Fluttertoast.showToast(
    msg: "Booking Information Deleted",
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

  Widget infoChild(double width, IconData icon,data2, data) => new Padding(
    padding: new EdgeInsets.only(bottom: 8.0),
    child: new InkWell(
      child: new Row(
        children: <Widget>[

          new Icon(
            icon,
            color: Colors.white,
            size: 30.0,
          ),
          new SizedBox(
            width: width / 30,
          ),
          new Text(data2,
            style: new TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),),

          new Text(data,  style: new TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.w400),)
        ],

      ),
      onTap: () {
        getdetail();
        print('Info Object selected');
      },
    ),
  );

}


