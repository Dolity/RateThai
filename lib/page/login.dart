import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testprojectbc/page/Navbar/homeNav.dart';
import 'package:testprojectbc/page/authenticator.dart';
import 'package:testprojectbc/page/curTest.dart';
import 'package:testprojectbc/page/currency.dart';
import 'package:testprojectbc/page/googleFA.dart';
import 'package:testprojectbc/page/selectCurency.dart';
import 'package:testprojectbc/page/smsFA.dart';
import 'package:testprojectbc/role/admin/nav/navHelperAdmin.dart';
import 'package:testprojectbc/role/agency/nav/navHelper.dart';
import '../models/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Setting/Theme.dart';
import 'addPost.dart';
import 'curinfo.dart';
import 'Navbar/loginsuccess.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  bool isDarkTheme = false;
  bool value = false;
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final fb = FacebookLogin();

  var loading = false;

  final db = FirebaseFirestore.instance;

  late final String displayName;

  final usersRef = FirebaseFirestore.instance.collection('usersPIN');

  @override
  Widget build(BuildContext context) {
    isDarkTheme = isDarkTheme;
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
                        "Thai",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        "Exchange",
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
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white),
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
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white),
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
                              primary: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              onPrimary: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              fixedSize: const Size(260, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                print(
                                    "email = ${profile.email}, password = ${profile.password}");
                                try {
                                  final authResult = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: profile.email!,
                                    password: profile.password!,
                                  );
                                  final user = authResult.user;
                                  String? keepName = profile.email;
                                  print('DisplayName: $keepName');
                                  formKey.currentState!.reset();
                                  if (user != null) {
                                    print('user have data');
                                    final userDoc =
                                        await usersRef.doc(user.uid).get();

                                    // Map<String, dynamic> userData = {
                                    //   'displayName': user.email,
                                    //   // เพิ่มข้อมูลอื่นๆ ที่คุณต้องการเก็บได้ตามต้องการ
                                    // };

                                    // await FirebaseFirestore.instance
                                    //     .collection('usersPIN')
                                    //     .doc(user.uid)
                                    //     .set({'displayName': user.email});

                                    if (userDoc.exists) {
                                      print('userDoc have exists');
                                      final data = userDoc.data()
                                          as Map<String, dynamic>?;

                                      if (data != null &&
                                          data.containsKey('role')) {
                                        print('condition[role]');
                                        String role = data['role'];
                                        switch (role) {
                                          case "user":
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GooglefaPage()),
                                            );
                                            break;
                                          case "agency":
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavHleperAgencyPage()),
                                            );
                                            break;
                                          case "admin":
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NavHleperAdminPage()),
                                            );
                                            break;
                                          default:
                                            Fluttertoast.showToast(
                                              msg: "Error Can't Authorize!",
                                              gravity: ToastGravity.CENTER,
                                            );
                                            print("Error Can't Authorize!");
                                            break;
                                        }
                                      } else {
                                        print('conditionCrateROLE');
                                        await usersRef.doc(user.uid).update({
                                          'role': "user",
                                          'UID': user.uid,
                                          'displayName': keepName,
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Save to Status on Firestore Success! (Update)'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GooglefaPage()),
                                        );
                                      }
                                    } else {
                                      print('userDocNot.exists');
                                      await usersRef.doc(user.uid).set({
                                        'role': "user",
                                        'UID': user.uid,
                                        'displayName': keepName,
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Save to Status on Firestore Success! (Update)'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GooglefaPage()),
                                      );
                                    }
                                  }
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.message!,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                              }
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
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return AddpostPage();
                          }));
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
                              fixedSize: const Size(150, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {
                              loginWithGoogle(context);
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

    final authResult = await FirebaseAuth.instance
        .signInWithCredential(GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    ));

    print(user);

    final userDoc = authResult.user;
    Map<String, dynamic> userData = {
      'displayName': user.displayName,
      // เพิ่มข้อมูลอื่นๆ ที่คุณต้องการเก็บได้ตามต้องการ
    };
    await FirebaseFirestore.instance
        .collection('usersPIN')
        .doc(userDoc!.uid)
        .set(userData, SetOptions(merge: true));

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return (GooglefaPage());
    })); // after success route to home.
  }

  // Future<void> saveUser(GoogleSignInAccount account) async {
  //   FirebaseFirestore.instance.collection("Users").doc(account.email).set({
  //     "email": account.email,
  //     "name": account.displayName,
  //     "profilepic": account.photoUrl
  //   });
  //   print("Saved User data");
  // }

  Future loginWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await _auth.signInWithCredential(facebookAuthCredential);

      print(loginResult);

      // Get the currently logged in user
      User? user = _auth.currentUser;

      if (user != null) {
        Map<String, dynamic> userData = {
          'displayName': user.displayName,
          // เพิ่มข้อมูลอื่นๆ ที่คุณต้องการเก็บได้ตามต้องการ
        };

        await FirebaseFirestore.instance
            .collection('usersPIN')
            .doc(user.uid)
            .set(
              userData,
              SetOptions(merge: true),
            );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, gravity: ToastGravity.CENTER
          // backgroundColor: Colors.blueGrey);
          );
    }

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return GooglefaPage();
    }));
  }
}
