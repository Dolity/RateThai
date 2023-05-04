import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';

import 'makePin.dart';

class HavePinPage extends StatefulWidget {
  @override
  _HavePinPage createState() => _HavePinPage();
}

class _HavePinPage extends State<HavePinPage> {
  String _pin = '';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  int _failedAttempts = 0;
  bool _isLocked = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void clearPin() {
    setState(() {
      _pin = '';
    });
  }

  void _onChangedPin(String pin) {
    if (_isLocked) {
      return;
    }

    if (pin.length == 6) {
      _checkPin(pin);
    }
  }

  Future<void> _checkPin(String pin) async {
    final querySnapshot = await usersRef.where('UID', isEqualTo: user).get();
    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      final existingPin = documentSnapshot.get('pin');
      if (existingPin == pin) {
        Navigator.of(context).pop(); // กลับไปยังหน้าก่อนหน้านี้
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: ((context) =>
        //         ReservationNav()))); คือการไปหน้าใหม่ อธิบายง่ายกว่าคือการเปิดหน้ามาซ้อนทับอีกที
        return;
      } else {
        clearPin();
      }
    }

    setState(() {
      _failedAttempts++;
      if (_failedAttempts >= 1) {
        _isLocked = true;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer(Duration(minutes: 3), () {
      setState(() {
        _failedAttempts = 0;
        _isLocked = false;
      });
    });
  }

  Widget _buildPinCodeWidget() {
    return PinCodeWidget(
      minPinLength: 6,
      maxPinLength: 6,
      onChangedPin: _onChangedPin,
      onEnter: (pin, _) async {
        if (!_isLocked && pin.length == 6) {
          await _checkPin(pin);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CreatePinPage()),
          );
        }
      },
    );
  }

  Widget _buildLockedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You have entered all wrong passwords.\nPlease make sure the code is correct.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 300),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HavePinPage()),
              );
            },
            child: Text('Got it'),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(350, 60), // กำหนดขนาดของปุ่ม
              padding: const EdgeInsets.symmetric(
                  vertical: 16), // กำหนดระยะห่างของข้อความจากขอบปุ่ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // กำหนดรูปร่างของปุ่ม
              ),
              backgroundColor: Colors.blue, // กำหนดสีพื้นหลังของปุ่ม
              textStyle: const TextStyle(
                  fontSize: 18), // กำหนดขนาดตัวอักษรของข้อความในปุ่ม
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สวัสดีคุณ $user'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'PIN CODE',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            const Text('You can use this PIN to unlock the Reservation'),
            const SizedBox(height: 20),
            //const Text('Pin length is 6 digits'),
            const SizedBox(height: 50),
            const Text('Please enter your PIN code:'),
            const SizedBox(height: 10),
            Expanded(
              child: _isLocked ? _buildLockedWidget() : _buildPinCodeWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
