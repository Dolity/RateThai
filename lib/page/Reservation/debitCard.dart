import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';

class PayDebitCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debit Card'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Debit Card Details'),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Card Number'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Expiration Date'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'CVV'),
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
      ),
    );
  }
}
