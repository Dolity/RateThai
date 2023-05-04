import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Navbar/ReservationNav.dart';
import 'makePin.dart';

class HavePinPage extends StatefulWidget {
  @override
  _HavePinPage createState() => _HavePinPage();
  static const String routeName = '/havePinPage'; // เพิ่มตรงนี้
}

class _HavePinPage extends State<HavePinPage> {
  String _pin = '';
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  int _failedAttempts = 0;
  bool _isLocked = false;
  Timer? _timer;
  late DateTime _loginTime; // สร้างตัวแปรเก็บเวลาที่ login สำเร็จ
  int _remainingSeconds = 0;
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

  void _onPinSuccess() {
    Navigator.pop(context, true); // ส่งค่า true กลับไปยังหน้า ReservationNav
  }

  Future<void> _checkPin(String pin) async {
    final querySnapshot = await usersRef.where('UID', isEqualTo: user).get();
    if (querySnapshot.docs.isNotEmpty) {
      final documentSnapshot = querySnapshot.docs.first;
      final existingPin = documentSnapshot.get('pin');
      if (existingPin == pin) {
        // กลับไปยังหน้าแรกของ BottomNavigationBar และ navigate ไปยังหน้าที่ต้องการ
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        _onPinFail(); // เรียกใช้ฟังก์ชัน _onPinFail() ในกรณีที่ PINCODE ผิด
      }
    }
  }

  void _onPinFail() {
    setState(() {
      _failedAttempts++;
      if (_failedAttempts >= 3) {
        _isLocked = true;
        _remainingSeconds = 30;
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_remainingSeconds > 0) {
              _remainingSeconds--;
            } else {
              _timer?.cancel();
              _timer = null;
              _isLocked = false;
              _failedAttempts = 0;
            }
          });
        });
      } else {
        clearPin();
      }
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

        if (_isLocked && _remainingSeconds <= 0) {
          setState(() {
            _isLocked = false;
            _remainingSeconds = 30;
          });
        }
      },
    );
  }

  Widget _buildLockedWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLocked) // display the countdown timer if the screen is locked
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'กรุณารอ $_remainingSeconds วินาที',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          Text(
            'You have entered all wrong passwords.\nPlease make sure the code is correct.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HavePinPage()),
              );
            },
            child: const Text('Got it'),
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
            Text(
              'Number of failed attempts: $_failedAttempts',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 50),
            const Text('Please enter your PIN code:'),
            const SizedBox(height: 10),
            Expanded(
              child: _isLocked
                  ? _buildLockedWidget(context)
                  : _buildPinCodeWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
