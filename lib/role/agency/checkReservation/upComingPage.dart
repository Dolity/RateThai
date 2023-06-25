import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';

class UpComingPage extends StatefulWidget {
  @override
  _UpComingPageState createState() => _UpComingPageState();
}

class _UpComingPageState extends State<UpComingPage> {
  String? _Cur;
  String? _Total;
  String? _fromUID;
  bool checkStatus = false;
  bool keepStatus = false;
  String qrCodeData = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upcoming'),
        ),
        body: Column(
          children: [
            if (keepStatus == true)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('ยืนยันการจอง'),
                        content: Text(
                            'คุณต้องการยืนยันการจองสกุลเงินนี้ใช่หรือไม่?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                checkStatus = true;
                              });
                              final user = globals.globalUID;
                              final usersRef = FirebaseFirestore.instance
                                  .collection('usersPIN');
                              final snapshot = await usersRef.doc(user).get();
                              if (snapshot.data()!['DateReserva'] != null ||
                                  snapshot.data()!['DateReserva'] == null) {
                                print('Updage data');
                                usersRef.doc(user).update({
                                  'ReservationStatus': '$checkStatus',
                                }).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Save to Status on FireStoreSuccess! (Update)'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to save Status on FireStoreSuccess!! (Update)'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                });
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('Allow'),
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                checkStatus = false;
                              });
                              final user = globals.globalUID;
                              final usersRef = FirebaseFirestore.instance
                                  .collection('usersPIN');
                              final snapshot = await usersRef.doc(user).get();
                              if (snapshot.data()!['DateReserva'] != null ||
                                  snapshot.data()!['DateReserva'] == null) {
                                print('Updage data');
                                usersRef.doc(user).update({
                                  'ReservationStatus': '$checkStatus',
                                }).then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Save to Status on FireStoreSuccess! (Update)'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to save Status on FireStoreSuccess!! (Update)'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                });
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('Not Allow'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    leading: checkStatus
                        ? Icon(Icons.check_circle)
                        : Icon(Icons.notification_important),
                    title: Text('${_Cur}'),
                    subtitle: Text('${_Total}'),
                  ),
                ),
              ),
          ],
        ));
  }
}
