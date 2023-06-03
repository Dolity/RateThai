import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:web3dart/web3dart.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  TextEditingController _textEditingControllerQR = TextEditingController();
  String _qrCodeData = '';
  String _dateReserva = '';
  String _payReserva = '';
  String _subAgencyReserva = '';
  String _total = '';

  @override
  void initState() {
    super.initState();
    fetchReservationData();
  }

  Future<void> fetchReservationData() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('usersPIN')
          .doc(user)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        setState(() {
          _dateReserva = data['DateReserva'] ?? '';
          _payReserva = data['PayReserva'] ?? '';
          _subAgencyReserva = data['SubAgencyReserva'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching reservation data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String agency =
        context.watch<ReservationData>().resevaProviAgencyUpdate.toString();
    String currency = context.watch<ReservationData>().resevaFromCur.toString();
    String rate =
        context.watch<ReservationData>().resevaProviRateUpdate.toString();
    String amount = context.watch<ReservationData>().resevaAmount.toString();
    _total = ((double.parse(rate)) * (double.tryParse(amount ?? '0.0') ?? 0.0))
        .toStringAsFixed(2);

    var notesServices = context.watch<NotesServices>();
    return notesServices.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('QR Code Generator'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textEditingControllerQR,
                    decoration: InputDecoration(
                      hintText: 'Enter data',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      print("DataProvider: $agency, $currency, $rate, $amount");
                      print(
                          "getFireStore: $_dateReserva, $_subAgencyReserva, $_payReserva");
                      final jsonMap = {
                        'Agency': agency,
                        'Currency': currency,
                        'Rate': rate,
                        'Amount': amount,
                        'Total': _total,
                        'Date': _dateReserva,
                        'SubAgency': _subAgencyReserva,
                        'Pay': _payReserva,
                      };

                      final jsonReservationData = jsonEncode(jsonMap);
                      setState(() {
                        _qrCodeData = jsonReservationData;
                      });
                      notesServices.addNote(
                          agency, currency, rate, amount, _total, _dateReserva);

                      Fluttertoast.showToast(
                        msg: 'Reservation Save On Blockchian Success \u2714',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                      );

                      print('total Money: $_total');
                      print('object: $_qrCodeData');
                      print('Data on BC: ${notesServices.notes}');
                    },
                    child: Text('Generate QR Code'),
                  ),
                  SizedBox(height: 16),
                  _qrCodeData.isNotEmpty
                      ? QrImageView(
                          data: _qrCodeData,
                          version: QrVersions.auto,
                          size: 200.0,
                        )
                      : Container(),
                  Text(context
                      .watch<ReservationData>()
                      .resevaProviAgencyUpdate
                      .toString()),
                  Text(context
                      .watch<ReservationData>()
                      .resevaFromCur
                      .toString()),
                  Text(context
                      .watch<ReservationData>()
                      .resevaProviRateUpdate
                      .toString()),
                  Text(
                      context.watch<ReservationData>().resevaAmount.toString()),
                  Text('DateReserva: $_dateReserva'),
                  Text('PayReserva: $_payReserva'),
                  Text('SubAgencyReserva: $_subAgencyReserva'),
                ],
              ),
            ),
          );
  }
}
