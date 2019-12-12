import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cat300/auth.dart';
import 'package:cat300/auth_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



import 'package:cat300/const.dart';


class Profile extends StatefulWidget {




  @override
  State<StatefulWidget> createState() {
    return ProfileState();

  }

}


class ProfileState extends State<Profile> {
  DocumentSnapshot snapshot;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
String check;
  FirebaseUser current;
   String email=" ";
   String name=" ";
   String mobilephone=" ";
   String matric=" ";
   String courses=" ";
   String User="";
  bool isLoading = false;

  String photoUrl = '';

File avatarImageFile;

  navigateToDetail()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));

  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }


  Future uploadFile() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();

    StorageReference reference = FirebaseStorage.instance.ref().child(uid);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('Student')
              .document(uid)
              .updateData({'photoUrl': photoUrl}).then((data) async {
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

  @override
  void initState()

  {
        super.initState();
        getUserInfoFromFirestore();
  }


 Future <void> getUserInfoFromFirestore() async {

   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
   final String uid = user.uid.toString();
   DocumentSnapshot snapshot = await Firestore.instance.collection('Student').document(uid).get();
   this.snapshot = snapshot;
   name = snapshot['Name'];
   email =snapshot['email'];
   mobilephone= snapshot['Mobile Phone'];
   matric = snapshot['Matric Number'];
   courses = snapshot['Courses'];
   photoUrl = snapshot['photoUrl'];

   check=uid;

   setState(() {});
  }
   @override
  Widget build(BuildContext context) {

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Container(
        decoration: new BoxDecoration(

        image: DecorationImage(
        image: AssetImage("Assets/background.jpg"),
     fit: BoxFit.fill,
     ),
        ),
     child: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
                  const Color(4294954172),
                  const Color(452984831),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Container(
     child:SingleChildScrollView(

     child: new Stack(

                children: <Widget>[
                  new Align(
                    alignment: Alignment.center,
                    child: new Padding(
                      padding: new EdgeInsets.only(top: _height / 20),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          (avatarImageFile == null)
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
                              width: 150.0,
                              height: 150.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          )
                              : Icon(
                            Icons.account_circle,
                            size: 90.0,
                            color: Colors.transparent,
                          ))
                              : Material(
                            child: Image.file(
                              avatarImageFile,
                              width: 150.0,
                              height: 150.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(45.0)),
                            clipBehavior: Clip.hardEdge,
                          ),






                        ],
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: _height / 2.2),
                    child: new Container(
                      color: Colors.white,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: _height / 3,
                        left: _width / 40,
                        right: _width / 40),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    offset: new Offset(0.0, 2.0))
                              ]),
                          child: new Padding(
                            padding: new EdgeInsets.all(_width / 100),
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,

     children: <Widget>

                             [
                               Text(name

     ,style: new TextStyle(
     fontSize: 18.0,
     color: Colors.black,
     fontWeight: FontWeight.bold),

                               )
       ,
       FlatButton.icon(
         color: Colors.transparent,
         icon: Icon(Icons.add_a_photo, ), //`Icon` to display
         label: Text('Add Photo',style: new TextStyle(
             fontSize: 14.0,
             color: Colors.black,
             fontWeight: FontWeight.bold),), //`Text` to display
         onPressed:
         getImage,

       ),
     ]


                            ),


                          ),
                        ),

                        new Padding(
                          padding: new EdgeInsets.only(top: _height / 30),
                          child: new Column(
                            children: <Widget>[
                              infoChild(
                                  _width, Icons.email, 'Email : ',email),
                              infoChild(_width, Icons.call, 'Mobile Phone : ',mobilephone),
                              infoChild(
                                  _width, Icons.book,'Courses : ' ,courses),
                              infoChild(_width, Icons.add,'Matric Number : ',
                                  matric),


                            ],

                          ),
                        ),

                        new Padding( padding: new EdgeInsets.all(_width / 50),
                        child: new Row(                                mainAxisAlignment: MainAxisAlignment.spaceAround,

                            children: <Widget>[

     FlatButton.icon(onPressed: (){

       navigateToDetail();
       print(check);
     },

         icon:Icon(Icons.mode_edit,
       color: const Color(0xFFFFFFFF),
       size: 30,
     ), label: Text('EDIT PROFILE',
         style: new TextStyle(
             fontSize: 16.0,
             color: Colors.black,
             fontWeight: FontWeight.bold))),

                            IconButton(
                            icon: Icon(Icons.refresh,
     color: const Color(0xFFFFFFFF),
     size: 30,
     ),
     onPressed: (){


     },
     ),
            ]

                        )

                        ),

                      ],
                    ),

                  )
                ],

              ),
     ) ),
          ),
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
        ],
      ),
    );
  }



  Widget infoChild(double width, IconData icon,data2, data) => new Padding(
    padding: new EdgeInsets.only(bottom: 8.0),
    child: new InkWell(
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: width / 10,
          ),
          new Icon(
            icon,
            color: const Color(0xFFFFFFFF),
            size: 36.0,
          ),
          new SizedBox(
            width: width / 20,
          ),
          new Text(data2,
              style: new TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold),),

          new Text(data,style: new TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.w400),)
        ],
      ),
      onTap: () {
        print('Info Object selected');
      },
    ),
  );
}




class EditProfile extends StatefulWidget {





  @override
  State<StatefulWidget> createState() {
    return EditProfileState();

  }

}

class EditProfileState extends State<EditProfile> {


  TextEditingController matricInputController;
  TextEditingController mobileInputController;
  TextEditingController courseInputController;
  TextEditingController nameInputController;

  FirebaseUser current;
  DocumentSnapshot snapshot;

  bool isLoading = false;

  String photoUrl = '';

  File avatarImageFile;

  final _formKey = GlobalKey<FormState>();

  void getCurrentUser() async {
    current = await FirebaseAuth.instance.currentUser();
  }

  initState() {
    matricInputController = new TextEditingController();
    mobileInputController = new TextEditingController();
    courseInputController = new TextEditingController();
    nameInputController = new TextEditingController();

    this.getCurrentUser();

    super.initState();
  }


  Future <void> update() async {
    {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final String uid = user.uid.toString();


      Firestore.instance
          .collection("Student").document(uid).updateData(
          {
            'Name': nameInputController.text,
            'Mobile Phone': mobileInputController.text,
            'Courses': courseInputController.text,
            'Matric Number': matricInputController.text,
          }).whenComplete(()=>
          Fluttertoast.showToast(
              msg: "Profile Updated",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 20
          ));


      Navigator.of(context).pop(); // dismiss dialog


    }

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
            title: Text('Edit Profile')
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          new Align(
                              alignment: Alignment.center,
                              child: new Padding(
                                  padding: new EdgeInsets.only(
                                      top: _height / 60),
                                  child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[


                                        Form(
                                          key: _formKey,


                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 35.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'Full Name'
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  ),
                                                  validator: (text) {
                                                    if (text.isEmpty) {
                                                      return "Please enter your Full Name ";
                                                    }
                                                    return null;
                                                  },
                                                  controller: nameInputController,
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'Mobile Phone'
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  ),
                                                  validator: (text) {
                                                    if (text.isEmpty) {
                                                      return "Your mobile phone number without '-' ";
                                                    }
                                                    return null;
                                                  },
                                                  controller: mobileInputController,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'Matric Number'
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  ),
                                                  validator: (text) {
                                                    if (text.isEmpty) {
                                                      return "Your Matric Number";
                                                    }
                                                    return null;
                                                  },
                                                  controller: matricInputController,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 25.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      labelText: 'Course Taken'
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  ),
                                                  controller: courseInputController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 40.0, bottom: 40.0),
                                          child: MaterialButton(
                                              child: Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25.0,
                                                ),
                                              ),
                                              color: Colors.red,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height / 12,
                                              minWidth: double.infinity,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),

                                              onPressed: update

                                          ),
                                        ),

                                      ]
                                  )
                              )
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}