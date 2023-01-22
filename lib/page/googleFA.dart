import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:testprojectbc/page/loginsuccess.dart';



class GooglefaPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return _GooglefaPage();
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

class _GooglefaPage extends State<GooglefaPage> {

  final String _authKeySecret = base32.encodeString('jakkrit');
  String? _currentCode;
  String? title;

  bool light = true;
  bool verifyResult = false;

  TextEditingController text2faController = TextEditingController();
  String currentText = "";

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
                    onChanged: (bool value){

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
                  onChanged: (value) {

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

                    if(value.length == 6){
                      var secret = base32.encodeString('jakkrit');
                      var verify = OTP.constantTimeVerification(timedCode, value);

                      if (verify){
                        print("TOTP Passed!");
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context){
                              return (LoginSuccessPage());
                            }));
                      } else {
                        print("TOTP Not Pass!");
                        setState(() {
                          text2faController.clear();
                          verifyResult = true;
                        });
                      }
                    }
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
              ),
              (verifyResult) ? Text("Not pass! Phone") : Container(),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  child: BarcodeWidget(
                    width: 320,
                    height: 320,
                    data: "otpauth://totp/projectBC?secret=" + base32.encodeString('jakkrit') + "&issuer=Google",
                    barcode: Barcode.qrCode(),
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
