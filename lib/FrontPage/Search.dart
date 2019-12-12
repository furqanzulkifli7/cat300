
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cat300/const.dart';

class Search extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return SearchState();

  }


}






class SearchState extends State<Search> {
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

  }


  navigateToDetail(DocumentSnapshot post)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Detail(post: post,)));
  }

Future getposts() async{

  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  var firestore= Firestore.instance;
  QuerySnapshot qn = await firestore.collection('Registered Car').getDocuments();

  return qn.documents;

}




@override
  Widget build(BuildContext context) {


  return new Container

    (



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
            leading: ClipOval(
              child: Image.network((snapshot.data[index].data["Car Photo"]),
                width: 120,
                height: 600,
                fit: BoxFit.cover,
              ),
          ),
            trailing: Icon(Icons.keyboard_arrow_right),

            title: Text(carName=snapshot.data[index].data["Car Name"],style: new TextStyle(
                fontSize: 20.0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold),),
            subtitle: Text("Year Of Manufactured : "+snapshot.data[index].data["Car Manufacturing Year"],style: new TextStyle(
                fontSize: 14.0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.w600),),
onTap:() =>navigateToDetail(snapshot.data[index]),
          )

          ;
    });
  }
}
  ),



    decoration: new BoxDecoration(

        gradient: new LinearGradient(colors: [
          const Color(4294954172),
          const Color(0xFFFFFFFF),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)


        ,image: DecorationImage(
    image: AssetImage("Assets/background.jpg"),
    fit: BoxFit.fill,
    ),

));

  }

}

class Detail extends StatefulWidget{
final DocumentSnapshot post;

Detail({


  this.post


});
  @override
  State<StatefulWidget> createState() {
    return DetailState();

  }

}

class DetailState extends State<Detail> {
String location=" ";
String bookingID=" ";
  DateTime _dateTime;
  DateTime timer;
  double rental=0.00;
  String owner=" ";
  String phone=" ";

  var formattedDate=" ";
  var _time = "Not set";


  var returntime=" ";
var returndate=" ";

int rent=0;

  String datebook=" ";
  int _currentPrice = 1;
  bool isLoading = false;

  String photoUrl = '';

  File LicenseImage;


  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        LicenseImage = image;
        isLoading = true;
      });
    }
  }


  Future uploadFile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    StorageReference reference = FirebaseStorage.instance.ref().child("License").child(uid);
    StorageUploadTask uploadTask = reference.putFile(LicenseImage);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('Booking')
              .document(bookingID)
              .updateData({'License': photoUrl}).then((data) async {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }


  Future <void> addBooking() async {
    {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uidcust = user.uid.toString();
      final String uidcarowner= widget.post.data['uid'];


      final store= await       Firestore.instance
          .collection("Booking").add(
          {

            "Car Name": widget.post.data["Car Name"],
            "Car Owner ID": uidcarowner,
            "Customer ID": uidcust,
            "Booking Car ID": widget.post.data["Register Car UID"],
            "Starting Date": datebook,
            "Starting Time": _time,
            "Duration": _currentPrice,
            "Ending Date": returndate,
            "Ending Time": returntime,
            "Total Rent": rental,

          }).whenComplete(()=>
          Fluttertoast.showToast(
              msg: "Booking Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 20
          ));

      String  id= store.documentID;

      Firestore.instance
          .collection('Booking')
          .document(id)
          .updateData({'Booking ID': id});


      bookingID=id;

      uploadFile();


    }

  }


  _showDialog() {
    showDialog(
      context: context,
      child: new NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 72,
          initialIntegerValue: _currentPrice),
    ).then((value) {
      if (value != null) {
        setState(() => _currentPrice = value);

        var time=_dateTime;
        var time2=timer;

        print(_dateTime.hour);

        time= _dateTime.add((Duration(hours: _currentPrice)));

        time2= timer.add(Duration(hours: _currentPrice));

        returntime = "${time2.hour}-${time2.minute}";
        returndate = "${time.day}-${time.month}-${time.year}";


        String calc=widget.post.data["Car Rate"];

var myInt=int.parse(calc);
        assert(myInt is int);

        rent=_currentPrice*myInt;
        rental= rent.toDouble();
//Formula of calculation. Fix

        if(_currentPrice>=6 && _currentPrice<12)
      {
        rental=rental*95/100;
      }

        if(_currentPrice>=12 && _currentPrice<24)
        {
          rental=rental*90/100;
        }
        if(_currentPrice>=24 && _currentPrice<48)
        {
          rental=rental*85/100;
        }
        if(_currentPrice>=48 && _currentPrice<=71)
        {
          rental=rental*80/100;
        }
        if(_currentPrice>=72)
        {
          rental=rental*75/100;
        }



      }
    });
  }

  Future <void> getdetail() async
  {

 Firestore.instance.collection('Student').where("uid", isEqualTo: widget.post.data["uid"]).snapshots()
     .listen((data) =>
     data.documents.forEach((doc) => owner=doc["Name"], ));


 Firestore.instance.collection('Student').where("uid", isEqualTo: widget.post.data["uid"]).snapshots()
     .listen((data) =>
     data.documents.forEach((doc) => phone=doc["Mobile Phone"], ));

 setState(() {});

  }



  @override
  void initState()

  {    getdetail();

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Make A Booking "),
        centerTitle: true,
      ),
      body: Container(
child:SingleChildScrollView(
        child: Center(
      child: Column(
           children:[ CircleAvatar(
            child: Image.network((widget.post.data["Car Photo"]),

              fit: BoxFit.contain,

            ),
             backgroundColor: Colors.transparent,
             radius: 150.0,

           ),
        Container(
          width: MediaQuery.of(context).size.width /1.2,

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

                      ,style: new TextStyle(
                          fontSize: 23.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),),



      ]
      ),

       ) ,

             new Align(
                 alignment: Alignment.center,
                 child: new Padding(
                     padding: new EdgeInsets.only(top: _height / 40),

           child:Column(

               children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width /1.2,
                   decoration: new BoxDecoration(

                       boxShadow: [
                         new BoxShadow(
                             color: Colors.black45,
                             blurRadius: 2.0,
                             offset: new Offset(0.0, 2.0))
                       ]
,
                       gradient: new LinearGradient(colors: [
                   const Color(4294954172),
                     const Color(452984831),
                     ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                   ),

                   child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: <Widget>
                       [
                         infoChild(_width, Icons.person, "Owner Name  :" , owner),
                   SizedBox(
                   height: 10,
                 ),
                         infoChild(_width, Icons.phone_android, "Phone Number   :" , phone),

                         SizedBox(
                           height: 10,
                         ),
                         infoChild(_width, Icons.event_seat, "Number Of Seat   :" , widget.post.data["Seat"]),
                         SizedBox(
                           height: 10,
                         ),
                         infoChild(_width, Icons.bookmark_border, "Car Brand   :" , widget.post.data["Car Brand"]),

                         SizedBox(
                           height: 10,
                         ),
                         infoChild(_width, Icons.attach_money, "Car Rate (Per Hour)   :" , widget.post.data["Car Rate"]),


                         SizedBox(
                           height: 10,
                         ),


                       ]

                   ),

                 ),
                 Padding(padding: new EdgeInsets.only(top: _height / 40)),

Container(



  width: MediaQuery.of(context).size.width /1.2,
  decoration: new BoxDecoration(


  ),

  child: Column(



      children: <Widget>[

         new Padding(
        padding: new EdgeInsets.only(top: _height / 20),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (LicenseImage == null)
                  ? (photoUrl != ''
                  ? Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                    width: 90.0,
                    height: 90.0,
                    padding: EdgeInsets.all(20.0),
                  ),
                  imageUrl: photoUrl,
                  width: 200.0,
                  height: 200.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                clipBehavior: Clip.hardEdge,
              )
                  : Icon(
                Icons.credit_card,
                size: 90.0,
                color: Colors.black,

              ))

                  : Material(
                child: Image.file(
                  LicenseImage,
                  width: 150.0,
                  height: 150.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                clipBehavior: Clip.hardEdge,
              ),

              FlatButton.icon(
                color: Colors.transparent,
                icon: Icon(Icons.add_a_photo, ), //`Icon` to display
                label: Text('Upload Your Driving License',style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),), //`Text` to display
                onPressed:
                getImage,

              ),            ]
  )
)
                 ,
Padding(padding: new EdgeInsets.only(top: _height / 40)),
                 Container(
                 width: MediaQuery.of(context).size.width /1.2,
             decoration: new BoxDecoration(

                 boxShadow: [
                   new BoxShadow(
                       color: Colors.black45,
                       blurRadius: 2.0,
                       offset: new Offset(0.0, 2.0))
                 ]
                 ,
                 gradient: new LinearGradient(colors: [
                   const Color(4294954172),
                   const Color(0xB3FFFFFF),
                 ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
             ),


                   child: Column(



                   children: <Widget>[
                     Container(
                       width: MediaQuery.of(context).size.width /1.1,

                       decoration: new BoxDecoration(
                           color: Colors.white,
                           boxShadow: [
                             new BoxShadow(
                                 color: Colors.black,
                                 blurRadius: 2.0,
                                 offset: new Offset(0.0, 2.0))
                           ]),

                       child: new Row(
                           mainAxisAlignment: MainAxisAlignment.center,

                           children: <Widget>

                           [


                             Text("Detail Of Booking"

                               ,style: new TextStyle(
                                   fontSize: 23.0,
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold),),



                           ]
                       ),

                     ) ,
Container(

    width: MediaQuery.of(context).size.width /1.2,
    decoration: new BoxDecoration(

        boxShadow: [
          new BoxShadow(
              color: Colors.black45,
              blurRadius: 2.0,
              offset: new Offset(0.0, 2.0))
        ]
        ,
        gradient: new LinearGradient(colors: [
          const Color(0xB3FFFFFF),
          const Color(0xB3FFFFFF),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
    ),


                     child: Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                         children: <Widget>
                       [

                   FlatButton.icon(

                       onPressed: (){


    showDatePicker(
    context: context,
    initialDate: _dateTime == null ? DateTime.now() : _dateTime,
    firstDate: DateTime(2001),
    lastDate: DateTime(2021)
    ).then((date) {
    setState(() {
    _dateTime = date;
    formattedDate = "${_dateTime.day}-${_dateTime.month}-${_dateTime.year}";
    datebook=formattedDate.toString();
    });
    });

                       }, icon: Icon(Icons.date_range), label: Text("Starting Rental Date")


                     ,
                     shape: RoundedRectangleBorder(side: BorderSide(
                 color: Colors.white,
                     width: 3,
                     style: BorderStyle.solid
                 ), borderRadius: BorderRadius.circular(90)),

                   ),


                           Text(datebook)

                         ]
                     )
                     )
                     ,



                 Container(

                   width: MediaQuery.of(context).size.width /1.2,
                   decoration: new BoxDecoration(

                       boxShadow: [
                         new BoxShadow(
                             color: Colors.black45,
                             blurRadius: 2.0,
                             offset: new Offset(0.0, 2.0))
                       ]
                       ,
                       gradient: new LinearGradient(colors: [
                         const Color(0xB3FFFFFF),
                         const Color(0xB3FFFFFF),
                       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                   ),


                   child:Row(

                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,

                         children: <Widget>
                         [

                           FlatButton.icon(

                               onPressed: (){


                                 DatePicker.showTimePicker(context,
                                     theme: DatePickerTheme(
                                       containerHeight: 210.0,
                                     ),
                                     showTitleActions: true,
                                     onConfirm: (time) {


                                   _time =
                                       '${time.hour} : ${time.minute}';



                                   setState(() {

                                     timer=time;

                                   });
                                     },


                                     locale: LocaleType.en);
                                 setState(() {});


                               }, icon: Icon(Icons.timelapse), label: Text("Booking Time")

                           ,           shape: RoundedRectangleBorder(side: BorderSide(
                               color: Colors.white,
                               width: 3,
                               style: BorderStyle.solid
                           ), borderRadius: BorderRadius.circular(90)),

                           ),

                           Text("Time: "+_time)

                         ]

                   ))

                     ,

                     Container(

                         width: MediaQuery.of(context).size.width /1.2,
                         decoration: new BoxDecoration(

                             boxShadow: [
                               new BoxShadow(
                                   color: Colors.black45,
                                   blurRadius: 2.0,
                                   offset: new Offset(0.0, 2.0))
                             ]
                             ,
                             gradient: new LinearGradient(colors: [
                               const Color(0xB3FFFFFF),
                               const Color(0xB3FFFFFF),
                             ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                         ),


                         child:Row(

                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

                             children: <Widget>
                             [

                               FlatButton.icon(

                                 onPressed:  _showDialog, icon: Icon(Icons.arrow_forward_ios), label: Text("Rent Duration"),



                                 shape: RoundedRectangleBorder(side: BorderSide(
                                     color: Colors.white,
                                     width: 3,
                                     style: BorderStyle.solid
                                 ), borderRadius: BorderRadius.circular(90)),

                               ),


                                Text("$_currentPrice Hour"),

                             ]

                         )),
      Container(

                         width: MediaQuery.of(context).size.width /1.2,
                         decoration: new BoxDecoration(

                             boxShadow: [
                               new BoxShadow(
                                   color: Colors.black45,
                                   blurRadius: 2.0,
                                   offset: new Offset(0.0, 2.0))
                             ]
                             ,
                             gradient: new LinearGradient(colors: [
                               const Color(0xB3FFFFFF),
                               const Color(0xB3FFFFFF),
                             ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                         ),


                         child:Row(

                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

                             children: <Widget>
                             [

                               FlatButton.icon(

                                 onPressed: (){}, icon: Icon(Icons.timer), label: Text("Return Rental Car At :"),


                                 shape: RoundedRectangleBorder(side: BorderSide(
                                     color: Colors.white,
                                     width: 3,
                                     style: BorderStyle.solid
                                 ), borderRadius: BorderRadius.circular(90)),

                               ),


Text("Time: "+returntime)
                             ]

                         )),
                     Container(

                         width: MediaQuery.of(context).size.width /1.2,
                         decoration: new BoxDecoration(

                             boxShadow: [
                               new BoxShadow(
                                   color: Colors.black45,
                                   blurRadius: 2.0,
                                   offset: new Offset(0.0, 2.0))
                             ]
                             ,
                             gradient: new LinearGradient(colors: [
                               const Color(0xB3FFFFFF),
                               const Color(0xB3FFFFFF),
                             ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                         ),


                         child:Row(

                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

                             children: <Widget>
                             [

                               FlatButton.icon(

                                 onPressed: (){}, icon: Icon(Icons.date_range), label: Text("Return Rental Car  At :"),


                                 shape: RoundedRectangleBorder(side: BorderSide(
                                     color: Colors.white,
                                     width: 3,
                                     style: BorderStyle.solid
                                 ), borderRadius: BorderRadius.circular(90)),

                               ),


                               Text("Date :"+returndate)
                             ]

                         )),

                     Container(

                         width: MediaQuery.of(context).size.width /1.2,
                         decoration: new BoxDecoration(

                             boxShadow: [
                               new BoxShadow(
                                   color: Colors.black45,
                                   blurRadius: 2.0,
                                   offset: new Offset(0.0, 2.0))
                             ]
                             ,
                             gradient: new LinearGradient(colors: [
                               const Color(0xB3FFFFFF),
                               const Color(0xB3FFFFFF),
                             ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                         ),


                         child:Row(

                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

                             children: <Widget>
                             [

                               FlatButton.icon(

                                 onPressed: (){}, icon: Icon(Icons.monetization_on), label: Text("Total Rental Price :"),


                                 shape: RoundedRectangleBorder(side: BorderSide(
                                     color: Colors.white,
                                     width: 3,
                                     style: BorderStyle.solid
                                 ), borderRadius: BorderRadius.circular(90)),

                               ),


                               Text("Total = RM$rental")
                             ]

                         )),

                     Container(

                         width: MediaQuery.of(context).size.width /1.2,
                         decoration: new BoxDecoration(

                             boxShadow: [
                               new BoxShadow(
                                   color: Colors.black45,
                                   blurRadius: 2.0,
                                   offset: new Offset(0.0, 2.0))
                             ]
                             ,
                             gradient: new LinearGradient(colors: [
                               const Color(0xB3FFFFFF),
                               const Color(0xB3FFFFFF),
                             ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                         ),


                         child:Row(

                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,

                             children: <Widget>
                             [

                               FlatButton.icon(

                                   onPressed: (){                                                    showAlertDialog(context);
                                   }, icon: Icon(Icons.location_on), label: Text("Pick Location"),



                         shape: RoundedRectangleBorder(side: BorderSide(
                     color: Colors.white,
                         width: 3,
                         style: BorderStyle.solid
                     ), borderRadius: BorderRadius.circular(90)),

      ),

                               Text(location)


                             ]

                         ))
,
                   ],
                 )
                 ),
                 SizedBox(height: 10),
                 RaisedButton(
                   shape: new RoundedRectangleBorder(
                       borderRadius: new BorderRadius.circular(18.0),
                       side: BorderSide(color: Colors.greenAccent)),
                   onPressed: addBooking,
                   color: Colors.teal,
                   textColor: Colors.white,
                   child: Text("Book Now".toUpperCase(),
                       style: TextStyle(fontSize: 18)),
                 ),

               ],



             )
                 )

             ])


      ))]




      )
        )
)));

  }
showAlertDialog(BuildContext context) {
  TextEditingController _textFieldController = TextEditingController();

  // set up the buttons
  Widget remindButton = FlatButton(
    child: Text("Yes"),
    onPressed:  () {

      location=_textFieldController.text;
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });

  Widget cancelbutton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      });


  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text('Enter Location To Pick Your Car'),
    content: TextField(
      controller: _textFieldController,
      decoration: InputDecoration(hintText: "Nearby You"),
    ),
    actions: [
      cancelbutton,
      remindButton,

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

          new Text(data,  style: new TextStyle(
              fontSize: 14.0,
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