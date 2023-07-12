import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Setting/havePin.dart';
import 'package:testprojectbc/page/Setting/notifyAwesome.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';

import 'convertNav.dart';
import 'HomeNav.dart';
import '../Navbar/ProfileNav.dart';

class LoginSuccessPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginSuccessPage();
  }
}

class _LoginSuccessPage extends State<LoginSuccessPage> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final authen = FirebaseAuth.instance;
  int currentIndex = 0;
  String keepCur = "";
  String keepRate = "";
  String keepResevaProviRateUpdate = "";
  final user = FirebaseAuth.instance.currentUser!.uid;
  late SharedPreferences _preferences;
  bool? isVerify;

  void checkPriceChange(BuildContext context) async {
    print("checkPriceChange is OK");
    // keepCur = context.watch<ReservationData>().notifyCur.toString();
    // keepRate = context.watch<ReservationData>().notifyRate.toString();
    // keepResevaProviRateUpdate =
    //     context.watch<ReservationData>().resevaProviRateUpdate.toString();
    final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRefD1.doc(user).get();
    // final Keepdata1 = snapshot.data() as Map<String, dynamic>?;

    if (snapshot?['RateNoti'] != null) {
      // keepCur
      print("if checkPriceChange is OK");
      double previousRate =
          double.parse(snapshot['RateNoti']); //Rate from User set
      double currentRate =
          double.parse(snapshot['QRCode']['Rate']); //Rate from agency Scarping
      print('Notify: $previousRate,  $currentRate');

      if (currentRate > previousRate) {
        // แจ้งเตือนว่าราคาสกุลเงินขึ้น
        Future.delayed(Duration(seconds: 5), () {
          createReservationPositiveNotification(context);
        });
      } else if (currentRate < previousRate) {
        // แจ้งเตือนว่าราคาสกุลเงินลง
        Future.delayed(Duration(seconds: 5), () {
          createReservationNegativeNotification(context);
        });
      }
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final screens = [
    const HomeNav(),
    CalculatorNav(),
    ReservationNav(),
    ProfileNav(),
  ];

  @override
  Widget build(BuildContext context) {
    checkPriceChange(context);
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        currentIndex: currentIndex,
        onTap: (indexz) async {
          setState(() {
            currentIndex = indexz;
            // isVerify = false;

            print('currentIDX $currentIndex');
          });

          if (currentIndex == 2) {
            // Check Firestore for isVerify data
            final usersRef = FirebaseFirestore.instance.collection('usersPIN');
            final snapshot = await usersRef.doc(user).get();

            final isVerifyNAV = snapshot.get('isVerify') ?? false;
            print('isVerifyNAV: $isVerifyNAV');

            if (!isVerifyNAV) {
              print('isVerify: $isVerify');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerificationPage()),
              );
            } else {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ReservationNav()),
              // );
            }
          }
        },
        unselectedItemColor: Colors.grey[500],
        selectedItemColor: Colors.black,
        selectedFontSize: 16.0,
        unselectedFontSize: 14.0,
        iconSize: 26.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Icon(Icons.home_rounded)
                : Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Icon(Icons.calculate_rounded)
                : Icon(Icons.calculate_outlined),
            label: 'Convert',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? Icon(Icons.monetization_on_rounded)
                : Icon(Icons.monetization_on_outlined),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Icon(Icons.person_rounded)
                : Icon(Icons.person_outline_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
