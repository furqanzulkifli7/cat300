
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:cat300/const.dart';



class Register extends StatefulWidget {


  Register({Key key,}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return RegisterState();

  }

}

class RegisterState extends State<Register> {
  TextEditingController carnameController;
  TextEditingController plateController;
  TextEditingController priceController;
  TextEditingController brandController;
  TextEditingController yearController;
  TextEditingController seatController;
  String photoUrl2 = '';

  FirebaseUser current;
  String check;

  File images;

  String id='';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  initState() {
    carnameController  = new TextEditingController();
    plateController  = new TextEditingController();
    priceController  = new TextEditingController();
    brandController  = new TextEditingController();
    yearController  = new TextEditingController();
    seatController = new TextEditingController();

    this.getCurrentUser();

    super.initState();

  }
  void getCurrentUser() async {
    current = await FirebaseAuth.instance.currentUser();

  }



  Future uploadFile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();



    StorageReference reference = FirebaseStorage.instance.ref().child('Car Storage').child(id);
    StorageUploadTask uploadTask = reference.putFile(images);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl2 = downloadUrl;
          Firestore.instance
              .collection('Registered Car')
              .document(id)
              .updateData({'Car Photo': photoUrl2}).then((data) async {
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

  Future <void> addCar() async {
    {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();


      final store= await       Firestore.instance
          .collection("Registered Car").add(
          {
        "uid": uid,
        "Car Name": carnameController.text,
        "Car Plate": plateController.text,
        "Car Rate": priceController.text,
        "Car Brand": brandController.text,
        "Car Manufacturing Year": yearController.text,
            "Seat": seatController.text,
      });
      id= store.documentID;

      Firestore.instance
          .collection('Registered Car')
          .document(id)
          .updateData({'Register Car UID': id});

      uploadFile();
      Navigator.of(context).pop(); // dismiss dialog


      }

  }


  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        images = image;
        isLoading = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Container(

        child: new Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
            decoration: new BoxDecoration(

              image: DecorationImage(
                image: AssetImage("Assets/Backgroundowner.png"),
                fit: BoxFit.fill,
              ),
            ),
        child: new SingleChildScrollView(

        child: new Stack(

        children: <Widget>[
        new Align(
        alignment: Alignment.center,
        child: new Padding(
          padding: EdgeInsets.all(8.0),
    child: new Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
    (images == null)
    ? (photoUrl2 != ''
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
    imageUrl: photoUrl2,
    width: 200.0,
    height: 200.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(45.0)),
    clipBehavior: Clip.hardEdge,
    )
        : Icon(
    Icons.directions_car,
    size: 300.0,
    color: greyColor,
    ))
        : Material(
    child: Image.file(
      images,
    width: 300.0,
    height: 300.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(45.0)),
    clipBehavior: Clip.hardEdge,
    ),

      FlatButton.icon(
        color: Colors.transparent,
        icon: Icon(Icons.add_a_photo, ), //`Icon` to display
        label: Text('ADD YOUR CAR PHOTO',style: new TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.bold),), //`Text` to display
        onPressed:getImage
        ,
      ),

    Text('Registered Your Car With Us', style: new TextStyle(
    fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold
    )
    ),
      SizedBox(height: 15),


            new Form(
                key: _formKey,

child: Column(
    children: <Widget>[


      TextFormField(

        controller: carnameController,
        decoration: new InputDecoration

          (


          prefixIcon: Icon(Icons.turned_in,              color: Colors.white,
          ),

          labelText: "Car Name", labelStyle: new TextStyle(
            color: Colors.white,

          fontSize: 18
        ),

          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if(val.length==0) {
            return "Name Cannot Be Empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),
      ),
      SizedBox(height: 15),

       TextFormField(


        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.play_arrow,              color: Colors.white,
          ),

          labelText: "Car Plate Number",
          labelStyle: new TextStyle(
              color: Colors.white,

              fontSize: 18
          ),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if(val.length==0) {
            return "Number Plate Cannot Be Empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),

         controller: plateController,

       ),

      SizedBox(height: 15),

      TextFormField(

        controller: priceController,
        keyboardType: TextInputType.number,

        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.attach_money,              color: Colors.white,
          ),

          labelText: "Price Per Hour(Rate Price)",
          labelStyle: new TextStyle(
              color: Colors.white,

              fontSize: 18
          ),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if(val.length==0) {
            return "Must be more than 0";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),
      ),
      SizedBox(height: 15),

      TextFormField(

        controller: brandController,

        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.turned_in,              color: Colors.white,
          ),

          labelText: "Brand",
          labelStyle: new TextStyle(
              color: Colors.white,

              fontSize: 18
          ),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if(val.length==0) {
            return "Must not empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),
      ),
      SizedBox(height: 15),


      TextFormField(

        controller: seatController,
        keyboardType: TextInputType.number,

        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.event_seat,              color: Colors.white,
          ),

          labelText: "How Many People Can Sit",
          labelStyle: new TextStyle(
              color: Colors.white,

              fontSize: 18
          ),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(
            ),
          ),
          //fillColor: Colors.green
        ),

        validator: (val) {
          if(val.length==0) {
            return "Must not empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),

      ),
      SizedBox(height: 15),

      TextFormField(

        controller: yearController,

        keyboardType: TextInputType.number,

        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.calendar_today,              color: Colors.white,
          ),

          labelText: "Car Manufacturing Year",
          labelStyle: new TextStyle(
              color: Colors.white,

              fontSize: 18
          ),
          fillColor: Colors.white,
          border: new OutlineInputBorder(

            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(

            ),
          ),
          //fillColor: Colors.green
        ),
        validator: (val) {
          if(val.length==0) {
            return "Must not empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          color: Colors.white70,

          fontFamily: "Poppins",
        ),
      ),




    ]


    )


            ),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(10.0),
        splashColor: Colors.blueAccent,
        onPressed: () {

addCar();
        },
        child: Text(
          "Register",
          style: TextStyle(fontSize: 20.0),
        ),
      ),

    ]
    ) ),

    ),


          SizedBox(height: 15),
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
    ]


    )

        )

    )));
  }
}
