import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class QRScanPage extends StatefulWidget {
  final String uidQR;
  QRScanPage({required this.uidQR});

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String uidQR = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController _qrViewController;
  List qrCodeData = [];
  bool isShowingDialog = false;
  bool isDropMoney = false;
  bool? checkStatus;
  bool? keepStatus;
  String? _UID;
  bool? dropOffStatus;

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID

  @override
  void dispose() {
    _qrViewController.dispose();
    super.dispose();
    currentUser = authen.currentUser;
    if (currentUser != null) {
      usernameData = currentUser!.email ?? "";
      userUID = currentUser!.uid;
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    // print('User Null But Found UID ON FS');
    // final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
    // final snapshotGet = await usersRefGet.doc("pin").get();
    // if (snapshotGet.exists) {
    //   setState(() {
    //     _UID = snapshotGet.get('uid');
    //   });
    // }
    // print('Click UID: $_UID');
    // final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    // final snapshot = await usersRef.doc(_UID).get();

    setState(() {
      _qrViewController = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (isShowingDialog) {
        return; // ไม่ทำอะไรเพิ่มเติมหาก showDialog กำลังแสดงอยู่
      }

      setState(() {
        final jsonData = jsonDecode(scanData.code!);
        final splitRealData = jsonData.toString().split(':');
        final splitLast = splitRealData.toString().split(',');
        final trimData = splitLast
            .map((data) => data.replaceAll(',', '').replaceAll(' ', ''))
            .toList();
        qrCodeData = trimData;
      });

      print('data on QR: $qrCodeData');

      if (!isShowingDialog) {
        showDialog(
          context: context,
          builder: (context) {
            isShowingDialog = true;
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usersPIN')
                  .where('UID', isEqualTo: widget.uidQR)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData =
                        users[index].data() as Map<String, dynamic>;

                    final String _uidQR = userData['UID'];
                    final String _totalQR = userData['QRCode']['Total'];
                    final String _fName = userData['FirstName'];
                    final String _lName = userData['LastName'];

                    // if (snapshot.connectionState == ConnectionState.done) {
                    // if (snapshot.hasData) {
                    print('snap has Data');
                    // final firestoreData = snapshot.data!.data();
                    final qrCodeDataIndex = qrCodeData.join(',');
                    print('QR Code Data[index]: $qrCodeData');
                    print('QR Code Data[8]: ${qrCodeData[8]}');
                    print('QR Code Data[9]: ${qrCodeData[9]}');
                    print('QR Code Data[9]: ${_uidQR}');
                    print('QR Code Data[9]: ${_totalQR}');
                    // เปรียบเทียบข้อมูลใน qrCodeData กับ firestoreData
                    // if (qrCodeData[9] == firestoreData!['Total'] &&
                    //     qrCodeData[11] == firestoreData['SubAgencyReserva']) {

                    for (var i = 0; i < qrCodeData.length; i++) {
                      if (qrCodeData[i] == _totalQR
                          //qrCodeData[i] == _uidQR
                          ) {
                        print('Condition QR OK');

                        // qrCodeData[1] == firestoreData!['DateReserva'] &&
                        // qrCodeData[16] == firestoreData!['PayReserva'] {

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 300, 0, 0),
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16), // ปรับขนาดของขอบมน
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              // width: 150, // กำหนดความกว้างของ Card
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 0),
                                  // Center(
                                  //   child: Text(
                                  //     'ข้อมูลถูกต้องกรุณารอรับเงิน',
                                  //     style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 22,
                                  //       fontWeight: FontWeight.bold,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'ข้อมูลคุณ ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                            text:
                                                '$_fName $_lName ถูกต้องกรุณารอรับเงิน'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          dropOffStatus = true;
                                          // บันทึกข้อมูลลง Firestore หรือทำอย่างอื่นตามที่คุณต้องการ
                                          final usersRef = FirebaseFirestore
                                              .instance
                                              .collection('usersPIN');
                                          usersRef.doc(_uidQR).update({
                                            'DropOffStatus': dropOffStatus,
                                          });

                                          Navigator.pop(context); // ปิด Dialog
                                          isShowingDialog =
                                              false; // กำหนดให้ตัวแปร isShowingDialog เป็น false เพื่อบอกว่า showDialog ปิดแล้ว
                                          Navigator.pop(
                                              context); // Pop หน้าปัจจุบัน
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('ยอมรับ'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          dropOffStatus = false;
                                          // ทำอย่างอื่นตามที่คุณต้องการเมื่อบริษัทปฏิเสธการรับเงิน
                                          final usersRef = FirebaseFirestore
                                              .instance
                                              .collection('usersPIN');
                                          dropOffStatus = false;
                                          usersRef.doc(_uidQR).update({
                                            'DropOffStatus': dropOffStatus,
                                          });

                                          Navigator.pop(context); // ปิด Dialog
                                          isShowingDialog =
                                              false; // กำหนดให้ตัวแปร isShowingDialog เป็น false เพื่อบอกว่า showDialog ปิดแล้ว
                                          Navigator.pop(
                                              context); // Pop หน้าปัจจุบัน
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('ปฏิเสธ'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    // }

                    // ถ้าไม่เข้าเงื่อนไขข้างบนหรือไม่พบข้อมูลใน Firestore
                    return AlertDialog(
                      title: Text('QR Code Scanned'),
                      content: Text('Invalid QR Code Data'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // ปิด AlertDialog
                            isShowingDialog =
                                false; // กำหนดให้ตัวแปร isShowingDialog เป็น false เพื่อบอกว่า showDialog ปิดแล้ว
                            Navigator.pop(context); // Pop หน้าปัจจุบัน
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );

                    // } else {
                    //   // แสดง CircularProgressIndicator ในระหว่างที่รอข้อมูลจาก Firestore
                    //   return AlertDialog(
                    //     title: Text('QR Code Scanned'),
                    //     content: CircularProgressIndicator(),
                    //   );
                    // }
                  },
                );
              },
            );
          },
        );
      }
    });
  }

  Future<Map<String, dynamic>> handleQRCodeData(String qrData) async {
    // ดำเนินการตรวจสอบหรือประมวลผลข้อมูล QR Code ตามต้องการ

    setState(() {
      qrCodeData = qrData as List;
    });

    // แปลงข้อมูล QR Code จากสตริงเป็นแบบ JSON โดยใช้ตัวแปร qrData
    final decodedData = jsonDecode(qrData);

    // ดึงข้อมูลจาก Firestore ที่เกี่ยวข้องกับผู้ใช้
    // final user = globals.globalUID;
    String? user = UserSingleton().uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(user).get();

    final firestoreData = snapshot.data() as Map<String, dynamic>;
    return firestoreData;
  }

  @override
  Widget build(BuildContext context) {
    print('pass UID: ${widget.uidQR}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          // if (qrCodeData.isNotEmpty)
          // Positioned(
          //   top: 16,
          //   left: 16,
          //   right: 16,
          //   child: Container(
          //     padding: EdgeInsets.all(10),
          //     color: Colors.white,
          //     child: Column(
          //       children: [
          //         // Text(
          //         //   'QR Code Data: $qrCodeData',
          //         //   style: TextStyle(fontSize: 16),
          //         // ),

          //         // Text(
          //         //   'QR Code Data:[9] ${qrCodeData[9]}',
          //         //   style: TextStyle(fontSize: 16),
          //         // ),
          //         // Text(
          //         //   'QR Code Data:[14] ${qrCodeData[14]}',
          //         //   style: TextStyle(fontSize: 16),
          //         // ),

          //         // Text(
          //         //   'QR Code Data:[16] ${qrCodeData[16]}',
          //         //   style: TextStyle(fontSize: 16),
          //         // ),
          //         // Text(
          //         //   'QR Code Data:[7] ${qrCodeData[7]}',
          //         //   style: TextStyle(fontSize: 16),
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
          Center(
            child: ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  primary: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Scan QR Code'),
                      content: Container(
                        width: 300,
                        height: 400,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: (QRViewController controller) {
                            _onQRViewCreated(controller);
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
