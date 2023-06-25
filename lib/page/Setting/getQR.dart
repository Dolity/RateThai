import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';

class GetQRCodePage extends StatelessWidget {
  final String qrCodeData;

  GetQRCodePage({required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    final qrCodeDataProvider = Provider.of<ReservationData>(context);
    final jsonMap = qrCodeDataProvider.qrCodeData?.toJson();
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Get QR Code'),
      ),
      body: Row(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            margin: EdgeInsets.all(10),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (jsonMap != null)
                      QrImageView(
                        data: jsonEncode(jsonMap),
                        version: QrVersions.auto,
                        size: 200,
                      )
                    else
                      Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
