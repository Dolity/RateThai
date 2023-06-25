import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';
import 'package:testprojectbc/page/Reservation/qrCode.dart';

class PayCashCheerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Cheer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'You have chosen Cash Cheer',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              'Thank you for using our service!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodePage(
                    user: '',
                  ),
                ),
              );
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
