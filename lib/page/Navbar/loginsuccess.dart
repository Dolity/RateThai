import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Navbar/convertNav.dart';
import 'package:testprojectbc/page/Navbar/homeNav.dart';
import 'package:testprojectbc/page/Navbar/profileNav.dart';
import 'package:testprojectbc/page/Navbar/reservationNav.dart';
import 'package:testprojectbc/page/Setting/detailNotify.dart';
import 'package:testprojectbc/page/Setting/havePin.dart';
import 'package:testprojectbc/page/Setting/makePin.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:testprojectbc/page/curinfo2.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/emailFA.dart';
import 'package:testprojectbc/page/emailOTP.dart';
import 'package:testprojectbc/page/otpsuccess.dart';
import 'package:testprojectbc/page/screenOTP.dart';
import '../../models/profile.dart';
import '../curinfo.dart';
import '../login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class LoginSuccessPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginSuccessPage();
  }
}

class _LoginSuccessPage extends State<LoginSuccessPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final authen = FirebaseAuth.instance;
  int currentIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final screens = [
    HomeNav(),
    CalculatorNav(),
    ReservationNav(),
    ProfileNav(),
  ];

  void checkclickReservation() {
    if (currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HavePinPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (indexz) {
          setState(() {
            currentIndex = indexz;
            checkclickReservation();
          });
        },
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.house,
              ),
              label: 'Home',
              backgroundColor: Colors.grey[300]),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.calculate,
              ),
              label: 'Convert',
              backgroundColor: Colors.grey[300]),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.monetization_on,
              ),
              label: 'Reservation',
              backgroundColor: Colors.grey[300]),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.person_4_rounded,
              ),
              label: 'Profile',
              backgroundColor: Colors.grey[300]),
        ],
      ),
    );
  }
}

// PAGE HomeNav!!

// PAGE CalculatorNav!!

// PAGE ProfileNav!!
// class ProfileNav extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ProfilePage'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Center(
//         child: ListView(
//           children: [],
//         ),
//       ),
//     );
//   }
// }
