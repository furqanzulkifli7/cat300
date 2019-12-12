

import 'dart:async';
import 'dart:io';
import 'package:cat300/const.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cat300/Models/appConstants.dart' as prefix0;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cat300/Models/appConstants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:cat300/auth.dart';
import 'package:cat300/auth_provider.dart';

class SignUpPage extends StatefulWidget {

  static final String routeName = '/signUpPageRoute';


  SignUpPage({Key key,}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();


}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
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
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    matricInputController = new TextEditingController();
    mobileInputController = new TextEditingController();
    courseInputController = new TextEditingController();
    nameInputController = new TextEditingController();

    this.getCurrentUser();

    super.initState();
  }
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
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

  Future <void> signStudent() async {
    {
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailInputController.text, password: pwdInputController.text).
      then((firebaseUser) {
        Firestore.instance
            .collection("Student")
            .document(firebaseUser.uid)
            .setData({
          "uid": firebaseUser.uid,
          "Name": nameInputController.text,
          "email": emailInputController.text,
          "Matric Number": matricInputController.text,
          "Mobile Phone": mobileInputController.text,
          "Courses": courseInputController.text,
        });

        uploadFile();

      });
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailInputController.text,
        password: pwdInputController.text,
      );

    }
  }



    String emailvalidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Email format is invalid';
      } else {
        return null;
      }
    }

    @override
    Widget build(BuildContext context) {
      final _width = MediaQuery.of(context).size.width;
      final _height = MediaQuery.of(context).size.height;

      return Scaffold(
        appBar: AppBar(
            title: Text('Sign Up Student')
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
                      padding: new EdgeInsets.only(top: _height / 60),
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
                            size: 120.0,
                            color: Colors.black,

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


FlatButton.icon(onPressed: getImage, icon: Icon(Icons.camera), label: Text("Upload Your Profile"))




                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Please Enter The Following Information',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Student E-mail'
                      ),
                      style: TextStyle(
                        fontSize: 25.0,
                      ),

                      controller: emailInputController,
                      validator: emailvalidator,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: TextFormField(


                      decoration: InputDecoration(
                          labelText: 'Password'

                      ),
                      obscureText: true,

                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Your Password";
                        }
                        return null;
                      },
                      controller: pwdInputController,

                    ),
                  ),
                  Form(
                    key: _formKey,


                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0),
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
                          padding: const EdgeInsets.only(top: 25.0),
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
                          padding: const EdgeInsets.only(top: 25.0),
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
                          padding: const EdgeInsets.only(top: 25.0),
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
                    padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: MaterialButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        color: Colors.blue,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 12,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        onPressed: signStudent

                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      );
    }}