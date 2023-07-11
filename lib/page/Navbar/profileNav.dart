import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/getBalance.dart';
import 'package:testprojectbc/page/Setting/getQR.dart';
import 'package:testprojectbc/page/Setting/havePin.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';
import 'package:testprojectbc/screen/testBlockchain.dart';
import '../Setting/makePin.dart';
import '../otpsuccess.dart';
import '../Setting/Theme.dart';
import '../Navbar/ChangeEmailScreen.dart';
import '../Navbar/ForgotPasswordScreen.dart';

class ProfileNav extends StatefulWidget {
  @override
  _ProfileNav createState() => _ProfileNav();
}

class _ProfileNav extends State<ProfileNav> {
  bool _notificationEnabled = true;
  String _username = 'John Doe';

  void _toggleNotification(bool value) {
    setState(() {
      _notificationEnabled = value;
    });
  }

  Future<void> _editUsername() async {
    String? newUsername = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController =
            TextEditingController(text: _username);
        return AlertDialog(
          title: const Text('Edit username'),
          content: TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(usernameController.text);
              },
            ),
          ],
        );
      },
    );

    if (newUsername != null && newUsername.isNotEmpty) {
      setState(() {
        _username = newUsername;
      });
    }
  }

  void _editPin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePinPage()));
  }

  void _openHelp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => testBC()));
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return testBC();
    // }));
  }

  void changeEmail() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const changeEmailNav()));
  }

  void _forgotPassword() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
  }

  void verifyQR() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HavePinPage()));
  }

  void checkGetBalance() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GetBalancePage()));
  }

  void checkVerification() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => VerificationPage()));
  }

  final IconData _iconLight = Icons.wb_sunny;
  final IconData _iconDark = Icons.nights_stay;
  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (BuildContext context, themeChangeProvider, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  themeChangeProvider.darkTheme =
                      !themeChangeProvider.darkTheme;
                });
              },
              icon: Icon(themeChangeProvider.darkTheme
                  ? Icons.nightlight_round
                  : Icons.wb_sunny),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: _notificationEnabled,
                onChanged: _toggleNotification,
              ),
            ),
            ListTile(
              title: const Text('Username'),
              subtitle: Text(_username),
              onTap: () {
                _editUsername();
              },
            ),
            ListTile(
              title: const Text('Change PIN'),
              onTap: () {
                _editPin();
              },
            ),
            ListTile(
              title: const Text('Verify QR Code'),
              onTap: () {
                verifyQR();
              },
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () {
                _openHelp();
              },
            ),
            ListTile(
              title: const Text('Forgot Password'),
              onTap: () {
                _forgotPassword();
              },
            ),
            ListTile(
              title: const Text('Change Email'),
              onTap: () {
                changeEmail();
              },
            ),
            ListTile(
              title: const Text('Check Blockchain'),
              onTap: () {
                checkGetBalance();
              },
            ),
            ListTile(
              title: const Text('Verification'),
              onTap: () {
                checkVerification();
              },
            ),
          ],
        ),
      );
    });
  }
}
