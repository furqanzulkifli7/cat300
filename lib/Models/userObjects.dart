import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'appConstants.dart';

class Contact {

  String id;
  String firstName;
  MemoryImage displayImage;

  Contact({this.id="", this.firstName = "", this.displayImage});

  Future<void> getContactInfoFromFirestore() async {
    DocumentSnapshot snapshot = await Firestore.instance.collection('users').document(this.id).get();
    this.firstName = snapshot['firstName'] ?? "";
  }

  Future<MemoryImage> getImageFromStorage() async {
    if (displayImage != null) { return displayImage; }
    final String imagePath = "userImages/${this.id}/profile_pic.jpg";
    final imageData = await FirebaseStorage.instance.ref().child(imagePath).getData(1024*1024);
    this.displayImage = MemoryImage(imageData);
    return this.displayImage;
  }

  String getFullName() {
    return this.firstName;
  }

  User createUserFromContact() {
    return User(
      id: this.id,
      firstName: this.firstName,
      displayImage: this.displayImage,
    );
  }

}

class User extends Contact {

  DocumentSnapshot snapshot;
  String name;
  String email;
  String bio;
  String city;
  String matricnum;
  String mobile;
  String age;
  String courses;
  String country;

  String uid;


  User({String id = "", String firstName = "", MemoryImage displayImage,
    this.email = "", this.courses = "", this.name = "", this.mobile = "", this.matricnum = " ",
  }) :
        super(id: id, firstName: firstName, displayImage: displayImage) {
    Future<void> getUserInfoFromFirestore() async {
      DocumentSnapshot snapshot = await Firestore.instance.collection('Student')
          .document(this.id)
          .get();
      this.snapshot = snapshot;
      this.email = snapshot['email'] ?? "";
    }

    Future<void> getPersonalInfoFromFirestore() async {
      await getUserInfoFromFirestore();
      await getImageFromStorage();
    }


    Future<void> addUserToFirestore() async {
      Map<dynamic, dynamic> data = {
        "Name": this.firstName,
        "Matric Number": this.matricnum,
        "Mobile Phone": this.mobile,
        "email": this.email,
        "Courses": this.courses,
        "UID": this.uid
      };
      await Firestore.instance.document('Student/${this.id}').setData(data);
    }

    Future<void> updateUserInFirestore() async {


    }

    Future<void> addImageToFirestore(File imageFile) async {
      StorageReference reference = FirebaseStorage.instance.ref().child(
          'userImages/${this.id}/profile_pic.jpg');
      await reference
          .putFile(imageFile)
          .onComplete;
      this.displayImage = MemoryImage(imageFile.readAsBytesSync());
    }


    Contact createContactFromUser() {
      return Contact(
        id: this.id,
        firstName: this.firstName,
        displayImage: this.displayImage,
      );
    }


    Future<void> postNewReview(String text, double rating) async {
      Map<String, dynamic> data = {
        'dateTime': DateTime.now(),
        'name': AppConstants.currentUser.getFullName(),
        'rating': rating,
        'text': text,
        'userID': AppConstants.currentUser.id,
      };
      await Firestore.instance.collection('users/${this.id}/reviews').add(data);
    }
  }
}