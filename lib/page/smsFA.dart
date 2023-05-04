import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/Navbar/loginsuccess.dart';
import '../models/profile.dart';
import 'package:testprojectbc/page/login.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE
}

class SmsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmsPage();
  }
}

class _SmsPage extends State<SmsPage> {
  bool value = false;
  Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;

  late MobileVerificationState currenState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  late String verificationId;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();


  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential = await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if(authCredential?.user != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSuccessPage()));
      } else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSuccessPage()));
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));

    }

  }

  getMobileFormWidget(context){
    return Center(
      child: Column(
        children: [
          Spacer(),
          TextFormField(
            controller: phoneController,
            onSaved: (String? phone) {
              profile.phone = phone;
            },
            decoration: InputDecoration(
              hintText: "Phone Number",
            ),
          ),

          SizedBox(height: 16,),
          ElevatedButton(onPressed: () async{

            setState(() {
              showLoading = true;
            });



            await _auth.verifyPhoneNumber(
                phoneNumber: phoneController?.text,
                verificationCompleted: (phoneAuthCredential) async{
                  setState(() {
                    showLoading = false;
                  });
                  //signInWithPhoneAuthCredential(phoneAuthCredential);

                }, // verifly android
                verificationFailed: (verificationFailed) async{
                  setState(() {
                    showLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verificationFailed.message!)));

                },
                codeSent: (verificationId, resendingToken) async{
                  setState(() {
                    showLoading = false;
                    currenState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });

                }, // update UI form phon otp
                codeAutoRetrievalTimeout: (verificationId) async{

                }
            );
          },
            child: Text("SEND"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),

          ),
          Spacer(),
        ],
      ),
    );
  }


  getOtpFormWidget(context){
    return Center(
      child: Column(
        children: [
          Spacer(),
          TextField(
            controller: otpController,
            decoration: InputDecoration(
              hintText: "Enter OTP",
            ),
          ),

          SizedBox(height: 16,),
          ElevatedButton(onPressed: () async{
            final PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
            child: Text("VERIFY"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: showLoading ? Center(child: CircularProgressIndicator(),) : currenState == MobileVerificationState.SHOW_MOBILE_FORM_STATE ?
            getMobileFormWidget(context) :
            getOtpFormWidget(context),
          padding: EdgeInsets.all(20),

        )

      // Padding(
      //   padding:
      //   EdgeInsetsDirectional.fromSTEB(15, 30, 15, 15),
      //   child: ElevatedButton(
      //
      //     onPressed: () async {

      // if (!mounted) return;
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context){
      //       return LoginSuccessPage();
      //     }));

    );
  }


}