import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class GetQRCodePage extends StatefulWidget {
  final String qrCodeData;

  GetQRCodePage({required this.qrCodeData});

  @override
  _GetQRCodePageState createState() => _GetQRCodePageState();
}

class _GetQRCodePageState extends State<GetQRCodePage> {
  Map<String, dynamic>? keepQR;

  @override
  void initState() {
    super.initState();
    fetchQRCodeFromFirestore().then((fetchedQRCode) {
      setState(() {
        keepQR = fetchedQRCode;
        print('QR FS $keepQR');
      });
    });
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchQRCodeFromFirestore() async {
    final userPIN = FirebaseAuth.instance.currentUser!.uid;
    final usersRefGetQR = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRefGetQR.doc(userPIN).get();
    if (snapshot.exists) {
      return snapshot.get('QRCode');
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get QR Code'),
      ),
      body: Row(
        children: [
          Container(
            width: 370,
            height: 500,
            margin: EdgeInsets.all(10),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'QR Code',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (keepQR != null)
                      QrImageView(
                        data: jsonEncode(keepQR),
                        version: QrVersions.auto,
                        size: 200,
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
