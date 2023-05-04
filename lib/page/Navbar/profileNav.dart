import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Setting/makePin.dart';
import 'package:testprojectbc/page/otpsuccess.dart';

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

  void _editUsername() async {
    String? newUsername = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController usernameController =
            TextEditingController(text: _username);
        return AlertDialog(
          title: Text('Edit username'),
          content: TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: 'Enter new username',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OtpSuccessPage()));
  }

  void _forgotPassword() {
    // navigate to forgot password page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(
              value: _notificationEnabled,
              onChanged: _toggleNotification,
            ),
          ),
          ListTile(
            title: Text('Username'),
            subtitle: Text(_username),
            onTap: _editUsername,
          ),
          ListTile(
            title: Text('Change PIN'),
            onTap: _editPin,
          ),
          ListTile(
            title: Text('Help'),
            onTap: _openHelp,
          ),
          ListTile(
            title: Text('Forgot Password'),
            onTap: _forgotPassword,
          ),
        ],
      ),
    );
  }
}