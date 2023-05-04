import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Navbar/ReservationNav.dart';
import 'package:testprojectbc/page/Setting/havePin.dart';

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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final screens = [
    const HomeNav(),
    CalculatorNav(),
    ReservationNav(),
    ProfileNav(),
  ];
  void checkClickReservation() async {
    if (currentIndex == 2) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HavePinPage()),
      );
      if (result == true) {
        setState(() {
          currentIndex = 2;
        });
      } else {
        setState(() {
          currentIndex = 0;
        });
      }
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
            checkClickReservation();
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
