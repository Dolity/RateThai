import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/smsFA.dart';
import '../models/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

import 'loginsuccess.dart';

// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {






    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {

  bool value = false;
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FacebookLogin();

  var loading = false;

  // void _logInWithFacebook() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   try {
  //     final facebookLoginResult = await FacebookAuth.instance.login();
  //     final userData = await FacebookAuth.instance.getUserData();
  //
  //     final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
  //     await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //
  //     if (!mounted) return;
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context){
  //           return LoginSuccessPage();
  //         }));
  //
  //   }on FirebaseAuthException catch (e) {
  //     var content = '';
  //
  //     switch (e.code) {
  //       case 'account-exists-with-diffrent-credental':
  //         content = 'This account exists with a different sign in provider';
  //         break;
  //       case 'invalid-credential':
  //         content = 'Unknow error has occurred';
  //         break;
  //       case 'operation-not-allowed':
  //         content = 'This operation is not allowed';
  //         break;
  //       case 'user-disabled':
  //         content = 'This user you tried to log into is disabled';
  //         break;
  //       case 'user-not-found':
  //         content = 'This user you tried to log into was not found';
  //         break;
  //
  //     }
  //     showDialog(context: context, builder: (context) => AlertDialog(
  //       title: Text('Log in with facebook failed'),
  //       content: Text(content),
  //       actions: [TextButton(onPressed: () {
  //         Navigator.of(context).pop();
  //       }, child: Text('Ok'),
  //       )],
  //     ));
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }


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
          // if (snapshot.connectionState == ConnectionState.done)

          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(70, 100, 0, 0),
                      child: Text(
                        "HI",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        "Welcome",
                        textAlign: TextAlign.center,
                        // style: Theme.of(context).textTheme.headlineSmall,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 50, 80, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? email) {
                          profile.email = email;
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Please enter email!"),
                          EmailValidator(
                              errorText: "email formation not correct!")
                        ]),

                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: 'Username',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: const Icon(Icons.verified_user)),
                        controller: _usernameController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
                      child: TextFormField(
                        onSaved: (String? password) {
                          profile.password = password;
                        },
                        validator: RequiredValidator(
                            errorText: "Please enter password!"),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(50)),
                            prefixIcon: const Icon(Icons.password_rounded)),
                        controller: _passwordController,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              // minimumSize: const Size.fromWidth(20),
                              fixedSize: const Size(260, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),

                            onPressed: () async {


                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                print("email = ${profile.email}, password = ${profile.password}");
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: profile.email!,
                                          password: profile.password!).then((value){
                                            formKey.currentState!.reset();
                                            if (!mounted) return;
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(builder: (context){
                                                  return LoginSuccessPage();
                                                }));
                                  });
                                } on FirebaseAuthException catch (e) {
                                  // print(e);
                                  // print(e.languageCode);

                                  Fluttertoast.showToast(
                                      msg: e.message!,
                                      gravity: ToastGravity.CENTER
                                      // backgroundColor: Colors.blueGrey);
                                  );
                                }
                              }

                              // Navigator.pushNamed(context, "/loginsuccess-page", arguments: [
                              //
                              // ]);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: TextButton(
                        child: const Text("Forgot your password?"),
                        onPressed: () {

                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (context){
                          //       return SmsPage();
                          //     }));

                        },
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              // minimumSize: const Size.fromWidth(20),
                              fixedSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {

                              loginWithFacebook(context);
                              print(loginWithFacebook(context));

                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text('A SnackBar has been shown.'),
                            //     ),
                            //   );
                            // },
                              // message = _usernameController.text;

                              // Navigator.pushNamed(context, "/photo-page", arguments: [
                              //   // _usernameController.text,
                              //   // _passwordController.text
                              // ]);
                            },
                            label: Text(
                              'Facebook',
                              style: TextStyle(fontSize: 20),
                            ),
                            icon: Icon(Icons.facebook),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              // minimumSize: const Size.fromWidth(20),
                              fixedSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {

                              loginWithGoogle(context);



                              // Navigator.pushNamed(context, "/photo-page", arguments: [
                              //   // _usernameController.text,
                              //   // _passwordController.text
                              // ]);

                            },
                            label: Text(
                              'Google',
                              style: TextStyle(fontSize: 20),
                            ),
                            icon: Icon(Icons.g_mobiledata),
                          ),
                        ),
                      ],
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: TextButton(
                        child: const Text("Don't have an account ? Sign Up"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register-page",
                              arguments: []);
                        },
                      ),
                    )),
                  ],
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

  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user!.authentication;

    await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
        idToken: userAuth.idToken, accessToken: userAuth.accessToken, ));
    print(user);
    print(userAuth);

    if (!mounted) return;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context){
          return (GooglefaPage());

        })); // after success route to home.
  }


  Future loginWithFacebook(BuildContext context) async {

    FacebookLogin facebookLogin = FacebookLogin();
    // FacebookLoginResult result = await facebookLogin
    //     .logIn(permissions: [
    //   FacebookPermission.publicProfile,
    //   FacebookPermission.email,
    // ]);
    //
    // String token = result.accessToken!.token;
    // print("Access token = $token");
    // await _auth.signInWithCredential(FacebookAuthProvider.credential(token));

    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await _auth.signInWithCredential(facebookAuthCredential);

    } on FirebaseAuthException catch (e){
      Fluttertoast.showToast(
          msg: e.message!,
          gravity: ToastGravity.CENTER
        // backgroundColor: Colors.blueGrey);
      );
    }
    if (!mounted) return;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context){
          return GooglefaPage();
        }));

  }







}
