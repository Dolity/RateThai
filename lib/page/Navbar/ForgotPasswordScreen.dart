import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Setting/Theme.dart';
import '../Setting/forgotPW.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void _resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;

    try {
      await resetPassword(email, oldPassword, newPassword);
      print("เปลี่ยนรหัสผ่านสำเร็จ");
      emailController.clear();
      oldPasswordController.clear();
      newPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เปลี่ยนรหัสผ่านสำเร็จ')),
      );
    } catch (e) {
      print("เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน: $e')),
      );
    }
  }

  Future<void> resetPassword(
      String email, String oldPassword, String newPassword) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      await userCredential.user?.updatePassword(newPassword);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Styles.themeData(true, context); // ใช้สไตล์จาก Styles

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เปลี่ยนรหัสผ่าน',
          style: themeData.textTheme.titleLarge!.copyWith(
            color: themeData.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: themeData.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                style: themeData.textTheme.titleMedium!.copyWith(
                  color: themeData.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  labelStyle: themeData.textTheme.titleMedium!.copyWith(
                    color: themeData.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeData.colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: oldPasswordController,
                style: themeData.textTheme.titleMedium!.copyWith(
                  color: themeData.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'รหัสผ่านเดิม',
                  labelStyle: themeData.textTheme.titleMedium!.copyWith(
                    color: themeData.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeData.colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: newPasswordController,
                style: themeData.textTheme.titleMedium!.copyWith(
                  color: themeData.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: 'รหัสผ่านใหม่',
                  labelStyle: themeData.textTheme.titleMedium!.copyWith(
                    color: themeData.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeData.colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    themeData.colorScheme.primary,
                  ),
                ),
                onPressed: () => _resetPassword(context),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeData.colorScheme.onPrimary,
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
