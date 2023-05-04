import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/page/emailFA.dart';
import 'package:testprojectbc/page/emailOTP.dart';

import '../models/profile.dart';
import 'login.dart';

import 'package:firebase_database/firebase_database.dart';




class CurrencyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CurrencyPage();
  }
}

class _CurrencyPage extends State<CurrencyPage> {
  // bool value = false;
  // final formKey = GlobalKey<FormState>();
  // Profile profile = Profile();

  //final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // final authen = FirebaseAuth.instance;

  // String? keepRes;



//   void checkNull() {
//     if(authen.currentUser!.displayName! == null){
//       keepRes = authen.currentUser.;
//     }
// }
  //final CollectionReference _productRef = FirebaseFirestore.instance.
  //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
  //final Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream = FirebaseFirestore.instance.collection('Currency').doc('SPO').snapshots();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Users').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String,
                dynamic>;
            return ListTile(
              title: Text(data['email']),
              subtitle: Text(data['name']),
            );
          }).toList(),
        );
      },
    );
  }


  // Future getData()async {
  //   databaseReference.once().then((DataSnapshot snapshot) {
  //     print('Data : ${snapshot.value}');
  //   });
  // }

}
