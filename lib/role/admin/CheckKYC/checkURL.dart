import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckURLPage extends StatefulWidget {
  @override
  _CheckURLPageState createState() => _CheckURLPageState();
}

class _CheckURLPageState extends State<CheckURLPage> {
  // URL ที่ต้องการตรวจสอบ
  List<String> urls = [];
  Map<String, bool> _canAccessURLs = {};
  String? urlK79;
  String? urlSME;
  String? urlSRG;
  String? urlSRO;
  String? urlVPC;
  String? urlVSU;
  String? urlXNE;

  @override
  void initState() {
    super.initState();
    fetchUrlsFromFirestore();
  }

  // ดึง URLs จาก Firestore
  void fetchUrlsFromFirestore() async {
    try {
      await Firebase.initializeApp();
      final firestoreURL = FirebaseFirestore.instance.collection('keepUID');
      final snapshotURL = await firestoreURL.doc('pin').get();
      if (snapshotURL.exists) {
        setState(() {
          urlK79 = snapshotURL.get('urlK79');
          urlSME = snapshotURL.get('urlSME');
          urlSRG = snapshotURL.get('urlSRG');
          urlSRO = snapshotURL.get('urlSRO');
          urlVPC = snapshotURL.get('urlVPC');
          urlVSU = snapshotURL.get('urlVSU');
          urlXNE = snapshotURL.get('urlXNE');

          urls = [
            urlK79 ?? '',
            urlSME ?? '',
            urlSRG ?? '',
            urlSRO ?? '',
            urlVPC ?? '',
            urlVSU ?? '',
            urlXNE ?? '',
          ];
          // เริ่มต้นให้ค่าทุก URL เป็น false
          urls.forEach((url) {
            _canAccessURLs[url] = false;
          });
          print('urlK79 F init: $urlK79');
        });
        print('urlK79: $urlK79');
      }
    } catch (e) {
      print('Error fetching URLs from Firestore: $e');
    }
  }

  Future<void> checkURL(String url) async {
    try {
      // ตรวจสอบว่าสามารถเข้าถึง URL ได้หรือไม่
      final response = await http.get(Uri.parse(url));
      setState(() {
        _canAccessURLs[url] = response.statusCode == 200;
      });
    } catch (e) {
      // เกิดข้อผิดพลาดในการเข้าถึง URL
      setState(() {
        _canAccessURLs[url] = false;
      });
    }
  }

  void showPopup(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ผลการตรวจสอบ URL'),
          content: Text(
            _canAccessURLs[url]!
                ? 'เข้าใช้งานเว็บไซต์ได้ปกติ'
                : 'URL ผิดพลาด ไม่สามารถเข้าถึงได้',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ตรวจสอบ URL')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < urls.length; i++)
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // ทำการตรวจสอบ URL
                        await checkURL(urls[i]);
                        // แสดง Popup ผลการตรวจสอบ
                        showPopup(context, urls[i]);
                      },
                      child: Text(
                        'ตรวจสอบ ${urls[i]}',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                  if (i < urls.length - 1) Divider(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
