import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/page/login.dart';
import 'package:testprojectbc/page/loginsuccess.dart';
import '../models/profile.dart';


enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE
}

class EmailFAPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailFAPage();
  }
}

class _EmailFAPage extends State<EmailFAPage> {
  bool value = false;
  Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  FirebaseAuth _auth = FirebaseAuth.instance;

  late MobileVerificationState currenState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  late String verificationId;
  bool showLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  EmailAuth? emailAuth;


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
            controller: emailController,
            onSaved: (String? phone) {
              profile.phone = phone;
            },
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),


          SizedBox(height: 16,),
          ElevatedButton(onPressed: () async{

            setState(() {
              showLoading = false;
            });

            senOTP();
            currenState = MobileVerificationState.SHOW_OTP_FORM_STATE;



            // await _auth.verifyPhoneNumber(
            //     phoneNumber: emailController?.text,
            //     verificationCompleted: (phoneAuthCredential) async{
            //       setState(() {
            //         showLoading = false;
            //       });
            //       //signInWithPhoneAuthCredential(phoneAuthCredential);
            //
            //     }, // verifly android
            //     verificationFailed: (verificationFailed) async{
            //       setState(() {
            //         showLoading = false;
            //       });
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
            //
            //     },
            //     codeSent: (verificationId, resendingToken) async{
            //       setState(() {
            //         showLoading = false;
            //         currenState = MobileVerificationState.SHOW_OTP_FORM_STATE;
            //         this.verificationId = verificationId;
            //       });
            //
            //     }, // update UI form phon otp
            //     codeAutoRetrievalTimeout: (verificationId) async{
            //
            //     }
            // );
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

            verifyOTP();
            // final PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
            //     verificationId: verificationId,
            //     smsCode: otpController.text);
            //
            // signInWithPhoneAuthCredential(phoneAuthCredential);
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

  void senOTP() async{
    emailAuth?.sessionName = "Test Session";
    var res = await emailAuth?.sendOtp(recipientMail: emailController.text);
    if(res != null) {
      print("OTP Sent");
    } else {
      print("We could not Sent the OTP");
    }
  }

  void verifyOTP() async{
    var res = emailAuth?.validateOtp(recipientMail: emailController.text, userOtp: otpController.text);
    if(res != null){
      print("OTP Verified");
    } else {
      print("Invalid OTP");
    }
  }


}