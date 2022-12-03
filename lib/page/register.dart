import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/page/login.dart';
import '../models/profile.dart';


// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_util.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
// import 'lib.google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  bool value = false;
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  TextEditingController? emailInputController;
  TextEditingController? passwordInputController;
  TextEditingController? repassInputController;

  @override
  void initState() {
    super.initState();
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
    repassInputController = TextEditingController();
  }

  @override
  void dispose() {
    emailInputController?.dispose();
    passwordInputController?.dispose();
    repassInputController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              body: Form(
                key: formKey,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    decoration: BoxDecoration(
                        // color: Theme.of(context).backgroundColor,
                        ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 40, 1, 0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 60),
                            // fontFamily: 'Poppins',
                            // fontSize: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                          child: ListView(

                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                child: TextFormField(
                                  // key: formKey,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (String? email) {
                                    profile.email = email;
                                  },
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Please enter email!"),
                                    EmailValidator(errorText: "email formation not correct!")
                                  ]),


                                  controller: emailInputController,
                                  decoration: InputDecoration(
                                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    hintText: 'Enter your email',
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  // fontFamily: 'Lexend Deca',
                                  // color: Color(0xFF1D2429),
                                  // fontSize: 14,
                                  // fontWeight: FontWeight.normal,

                                  maxLines: null,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                child: TextFormField(
                                  obscureText: true,
                                  // key: formKey,
                                  onSaved: (String? password) {
                                    profile.password = password;
                                  },
                                  validator: RequiredValidator(errorText: "Please enter password!"),

                                  controller: passwordInputController,
                                  // maxLines: 1,
                                  decoration: InputDecoration(
                                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    hintText: 'Enter your password',
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  // fontFamily: 'Lexend Deca',
                                  // color: Color(0xFF1D2429),
                                  // fontSize: 14,
                                  // fontWeight: FontWeight.normal,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                child: TextFormField(
                                  // key: formKey,
                                  // onSaved: (String? password) {
                                  //   profile.password = password;
                                  // },

                                  controller: repassInputController,
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    hintText: 'Re-enter password',
                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF57636C),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFDBE2E7),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  // fontFamily: 'Lexend Deca',
                                  // color: Color(0xFF1D2429),
                                  // fontSize: 14,
                                  // fontWeight: FontWeight.normal,

                                  maxLines: null,
                                ),
                              ),

                              Padding(
                                padding:  EdgeInsetsDirectional.fromSTEB(0,20,0,0),
                                child: CheckboxListTile(
                                  title: Text("I agree Terms of Service"),
                                  value: value,
                                  onChanged: (newValue) {
                                    setState(() {
                                      value = newValue!;
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),

                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(15, 30, 15, 15),
                                child: ElevatedButton(

                                  onPressed: () async {
                                    if (formKey.currentState!.validate()){
                                      formKey.currentState?.save();
                                      print("email = ${profile.email}, password = ${profile.password}");
                                      try{
                                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                            email: profile.email!,
                                            password: profile.password!
                                        ).then((value){
                                          formKey.currentState?.reset();
                                          Fluttertoast.showToast(
                                            msg: "Create account success",
                                            gravity: ToastGravity.BOTTOM,
                                            // backgroundColor: Colors.blueGrey
                                          );
                                          if (!mounted) return;
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context){
                                                return LoginPage();
                                              }));
                                          });



                                      }on FirebaseAuthException catch(e){
                                        // print(e);
                                        // print(e.languageCode);

                                        Fluttertoast.showToast(
                                            msg: e.message!,
                                          gravity: ToastGravity.BOTTOM,
                                          // backgroundColor: Colors.blueGrey
                                        );
                                      }
                                    }



                                  },
                                  child: Text('SIGN UP'),

                                  style: ElevatedButton.styleFrom(
                                    // width: 150,
                                    // height: 50,
                                    // color: Color(0xFF4B39EF),

                                    textStyle: Theme.of(context).textTheme.headline6,
                                    // fontFamily: 'Lexend Deca',
                                    // color: Colors.white,
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,

                                    elevation: 2,
                                    primary: Colors.blue,
                                    // minimumSize: const Size.fromWidth(20),
                                    fixedSize: const Size(260, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)),
                                  ),
                                  // icon: Icon(Icons.navigate_next),


                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 15),
                                child: ElevatedButton(
                                  onPressed: () {
                                    print('Button pressed ...');
                                  },
                                  child: const Text('Login'),
                                  style: ElevatedButton.styleFrom(
                                    // width: 150,
                                    // height: 50,
                                    // color: Colors.white,

                                    textStyle: Theme.of(context).textTheme.headline6,


                                    // fontFamily: 'Lexend Deca',
                                    // color: Color(0xFF262D34),
                                    // fontSize: 14,
                                    // fontWeight: FontWeight.normal,
                                    elevation: 1,
                                    primary: Colors.white54,
                                    // minimumSize: const Size.fromWidth(20),
                                    fixedSize: const Size(260, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)),
                                  ),



                                ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });


  }
}
