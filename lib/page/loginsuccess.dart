import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../models/profile.dart';
import 'login.dart';

class LoginSuccessPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginSuccessPage();
  }
}

class _LoginSuccessPage extends State<LoginSuccessPage> {
  bool value = false;
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final authen = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 50, 0),
              child: Text(authen.currentUser!.email!,
                textAlign: TextAlign.center,
                // style: Theme.of(context).textTheme.headlineSmall,
                style: TextStyle(fontSize: 30),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
              child: ElevatedButton(
                  onPressed: () {
                    authen.signOut().then((value){
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context){
                            return LoginPage();
                          }));
                    });
                  },
                  child: Text("Sign out")

              ),
            )


          ],
        ),
      ),
    );
  }
}
