import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/role/agency/checkReservation/completedPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/qrCodeScanPage.dart';
import 'package:testprojectbc/role/agency/checkReservation/upComingPage.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import 'package:testprojectbc/screen/testBlockchainNoDel.dart';

class BookingStatusPage extends StatefulWidget {
  @override
  _BookingStatusPageState createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  QRViewController? _qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String? _Cur;
  String? _Total;
  String? _fromUID;
  bool checkStatus = false;
  bool keepStatus = false;
  String qrCodeData = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> fetchUserData() async {
    try {
      final user = globals.globalUID;

      final usersRef = FirebaseFirestore.instance.collection('usersPIN');
      final snapshot = await usersRef.doc(user).get();
      print('UID: $user');

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _Cur = data['CurrencyNoti'];
        _Total = data['Total'];
        if (snapshot.data()!['ReservationStatus'] == true) {
          keepStatus = true;
          print('true');
        } else {
          keepStatus = false;
          print('false');
        }
      }

      setState(() {
        _Cur = _Cur;
        _Total = _Total;
        keepStatus = keepStatus;
      });

      print('Currency: $_Cur');
      print('Total: $_Total');
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeData = scanData.code.toString();
      });

      handleQRCodeData(qrCodeData);
    });
  }

  void handleQRCodeData(String qrData) async {
    setState(() {
      qrCodeData = qrData;
    });
    // แปลงข้อมูล QR Code จากสตริงเป็นแบบ JSON โดยใช้ตัวแปร qrData
    final decodedData = jsonDecode(qrData);

    // ดึงข้อมูลจาก Firestore ที่เกี่ยวข้องกับผู้ใช้
    final user = globals.globalUID;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(user).get();

    if (snapshot.exists) {
      // แปลงข้อมูลใน Firestore เป็นแบบ JSON
      final firestoreData = snapshot.data() as Map<String, dynamic>;

      // เปรียบเทียบข้อมูลใน JSON กับ Firestore
      if (decodedData == firestoreData) {
        // ข้อมูลตรงกัน แสดงข้อความว่าข้อมูลการจองสกุลเงินถูกต้อง
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ผลการตรวจสอบ'),
            content: Text('ข้อมูลการจองสกุลเงินถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // ข้อมูลไม่ตรงกัน แสดงข้อความว่าข้อมูลการจองสกุลเงินไม่ถูกต้อง
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ผลการตรวจสอบ'),
            content: Text('ข้อมูลการจองสกุลเงินไม่ถูกต้อง'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeDataProvider = Provider.of<ReservationData>(context);
    print('Currency on Widget: $_Cur -- Total on Widget: $_Total');
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Status'),
        bottom: TabBar(
          labelColor: Colors.black,
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'QR Decode'),
            Tab(text: 'Blockchain'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UpComingPage(),
          CompletedPage(),
          QRScanPage(),
          testBCNoDel(),
        ],
      ),
    );
  }
}
