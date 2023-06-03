import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:testprojectbc/Service/provider/reservationData.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Setting/notify.dart';

class DetailNotifyPage extends StatefulWidget {
  @override
  _DetailNotifyPageState createState() => _DetailNotifyPageState();
}

class _DetailNotifyPageState extends State<DetailNotifyPage> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _fromCurrency = 'USD';
  String? _toCurrency = 'THB';
  double _exchangeRate = 0.0;
  String? _pin = " ";
  List<String> _currencies = ['AED', 'AUD', 'BHD', 'BND', 'USD', 'JPY', 'SGD'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!.uid;
  final usersRef = FirebaseFirestore.instance.collection('usersPIN');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rate Alerts'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: ListView(children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                SizedBox(
                    width: 350,
                    height: 270,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DropdownButtonFormField<String>(
                                    value: _fromCurrency,
                                    onChanged: (value) {
                                      setState(() {
                                        _fromCurrency = value;
                                      });
                                    },
                                    items: _currencies
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: _textEditingController,
                                    validator: RequiredValidator(
                                      errorText: "กรุณาใส่ค่าตัวเลข",
                                    ),
                                    style: TextStyle(fontSize: 30),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: '0.00',
                                      hintStyle: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      print("Click!!!!!!!!!!!!!");
                                      if (_formKey.currentState?.validate() ??
                                          true) {
                                        final notifyModel = NotificationModel(
                                          fromCurrency: _fromCurrency!,
                                          amount: _textEditingController.text,
                                        );
                                        // print('Currency: $_fromCurrency' 'Rate: $_textEditingController.text');
                                        context
                                            .read<ReservationData>()
                                            .notifyCur = _fromCurrency!;
                                        context
                                                .read<ReservationData>()
                                                .notifyRate =
                                            _textEditingController.text;
                                        usersRef.doc(user).update({
                                          // 'pin': pin,
                                          'UID': '$user',
                                          'CurrencyNoti': '$_fromCurrency',
                                          'RateNoti':
                                              '${_textEditingController.text}'
                                        }).then((_) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Save to FireStoreSuccess!'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }).catchError((error) {
                                          setState(() {
                                            // _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Failed to save PIN.'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        });

                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => notify(),
                                            ));
                                      }
                                    },
                                    child: Text(
                                      'สร้างการแจ้งเตือนสกุลเงิน',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 16),
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ])))),
              ])),
        ]));
  }
}
