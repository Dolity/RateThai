import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import 'dart:async';

class GooglefaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GooglefaPage();
  }
}

class _GooglefaPage extends State<GooglefaPage> {
  // final String _authKeySecret = base32.encodeString('jakkrit');
  String? _currentCode;
  String? title;

  bool light = true;
  bool verifyResult = false;

  TextEditingController text2faController = TextEditingController();
  String currentText = "";

  final userPIN = FirebaseAuth.instance.currentUser!.uid;
  // String otpauthLink = '';
  String mySecret = secret!;
  late final String _authKeySecret;
  late SharedPreferences _preferences;

  // String generateTOTP(String secret, int length, int interval) {
  //   int currentTime = DateTime.now().millisecondsSinceEpoch;
  //   String timedCode = OTP.generateTOTPCodeString(
  //     secret,
  //     currentTime,
  //     length: length,
  //     interval: interval,
  //     algorithm: Algorithm.SHA1,
  //     isGoogle: true,
  //   );
  //   return timedCode;
  // }

  Future<String> fetchMySecret() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usersPIN')
        .doc(userPIN)
        .get();
    if (snapshot.exists) {
      return snapshot.data()!['displayName'];
    }
    return '';
  }

  // "otpauth://totp/RateThai?secret=$mySecret&issuer=$mySecret",
  @override
  void initState() {
    super.initState();
    fetchMySecret().then((secret) async {
      setState(() {
        mySecret = secret;
        // String otpauthLink =
        //     'otpauth://totp/RateThai?secret=$mySecret&issuer=$mySecret';
        _authKeySecret = base32.encodeString(mySecret);
        print('mySecret FS inti: $mySecret');
      });
      _preferences = await SharedPreferences.getInstance();
      // เรียกใช้งานเพื่อตรวจสอบสถานะ TOTP session
      bool isTOTPSessionValid = await _checkTOTPSession();
      if (isTOTPSessionValid) {
        // TOTP session ยังไม่หมดอายุและผ่านการตรวจสอบ
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginSuccessPage();
        }));
      }
    });
  }

  Future<void> _saveTOTPSession(bool success) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await _preferences.setInt('totp_last_success_time', currentTime);
    await _preferences.setBool('totp_verification_success', success);
  }

  Future<bool> _checkTOTPSession() async {
    final lastSuccessTime = _preferences.getInt('totp_last_success_time') ?? 0;
    final verificationSuccess =
        _preferences.getBool('totp_verification_success') ?? false;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final difference = currentTime - lastSuccessTime;
    return verificationSuccess &&
        difference <= (5 * 60 * 1000); // 5 minutes in milliseconds
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2FA"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'TOTP Auth',
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 25, 0.0, 0.0),
                child: Switch(
                    value: light,
                    activeColor: Colors.blueAccent,
                    onChanged: (bool value) {
                      setState(() {
                        light = value;
                        //qrGEN();
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  controller: text2faController,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) async {
                    int currentTime = DateTime.now().millisecondsSinceEpoch;
                    var timedCode = OTP.generateTOTPCodeString(
                      _authKeySecret,
                      currentTime,
                      length: 6,
                      interval: 30,
                      algorithm: Algorithm
                          .SHA1, // PLEASE change this from default/ suggested SHA1 which is a lot less secure
                      isGoogle: true,
                    );
                    setState(() {
                      _currentCode = timedCode;
                    });

                    if (value.length == 6) {
                      var secret = base32.encodeString(mySecret);
                      var verify =
                          OTP.constantTimeVerification(timedCode, value);
                      FirebaseFirestore.instance
                          .collection('usersPIN')
                          .doc(userPIN)
                          .get()
                          .then((snapshot) async {
                        if (snapshot.exists) {
                          // String timedCode = generateTOTP(mySecret, 6, 30);
                          print('value press: $mySecret');
                          print('timeCode: $timedCode');

                          if (verify) {
                            //value == timedCode
                            // TOTP ถูกต้อง
                            // นำผู้ใช้ไปยังหน้า LoginSuccessPage()
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginSuccessPage();
                            }));
                            Fluttertoast.showToast(
                              msg: 'TOTP Pass ✅',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                            );
                            await _saveTOTPSession(true);
                          } else {
                            // TOTP ไม่ถูกต้อง
                            setState(() {
                              text2faController.clear();
                              verifyResult = true;
                            });
                            Fluttertoast.showToast(
                              msg: 'TOTP Wrong ❌',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                            );
                            await _saveTOTPSession(true);
                          }
                        }
                      });
                    }
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
              ),
              (verifyResult) ? Text("Not pass! Phone") : Container(),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Scan TOTP Auth',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            print('onPressed: $mySecret');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(''),
                                  content: Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: BarcodeWidget(
                                      width: 320,
                                      height: 320,
                                      data: "otpauth://totp/RateThai?secret=" +
                                          base32.encodeString(mySecret) +
                                          "&issuer=$mySecret",
                                      barcode: Barcode.qrCode(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            print('GenQR: $mySecret');
                            // print('otpauthLink: $otpauthLink');
                          },
                          child: Text('Scan QR Code'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
