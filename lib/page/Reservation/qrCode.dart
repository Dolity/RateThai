import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/page/Reservation/genQR.dart';

class PayQRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String rate =
        context.watch<ReservationData>().resevaProviRateUpdate.toString();
    String amount = context.watch<ReservationData>().resevaAmount.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'QR Code',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/qrDLT.jpg?alt=media&token=9a963538-348c-4510-bf5d-8b6499a89373&_gl=1*joek9b*_ga*MTc1MTk3OTY5MC4xNjc2OTY0MDg2*_ga_CW55HF8NVT*MTY4NjA0MTIxMy42Ni4xLjE2ODYwNDMwODguMC4wLjA.',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pay: ${double.parse(rate) * double.parse(amount)} THB',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
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
            child: Text('Scan QR Code'),
          ),
        ],
      ),
    );
  }
}
