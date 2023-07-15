import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  String? _Cur;
  String? _Total;
  String? _Type;
  String? _Rate;
  String? _DateReservation;
  String? _SubAgency;
  String? _fromUID;
  bool checkStatus = false;
  bool keepStatus = false;
  String qrCodeData = '';

  // Future<void> fetchData() async {
  //   String? user = UserSingleton().uid;

  //   // บันทึกข้อมูลใน Firestore หาก user ไม่เป็น null
  //   // if (user != null) {
  //   // final usersRefUpdate = FirebaseFirestore.instance.collection('keepUID');
  //   // await usersRefUpdate.doc("pin").update({'uid': user});
  //   // print('UID Saved');

  //   // ดึงข้อมูลจาก Firestore ตามปกติ
  //   // final usersRef2 = FirebaseFirestore.instance.collection('usersPIN');
  //   // final snapshot = await usersRef2.doc(user).get();
  //   // if (snapshot.exists) {
  //   //   setState(() {
  //   //     _Total = snapshot.get('Total');
  //   //     _DateReservation = snapshot.get('DateReserva');
  //   //     _Type = snapshot.get('PayReserva');
  //   //     _SubAgency = snapshot.get('SubAgencyReserva');
  //   //     checkStatus = snapshot.get('ReservationStatus');
  //   //   });
  //   // }
  //   // } else {
  //   print('User Null But Found UID ON FS');
  //   final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
  //   final snapshotGet = await usersRefGet.doc("pin").get();
  //   if (snapshotGet.exists) {
  //     setState(() {
  //       _UID = snapshotGet.get('uid');
  //     });
  //   }

  //   // ดึงข้อมูลจาก Firestore ด้วย _UID ที่ได้จาก Firestore ก่อนหน้า
  //   final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  //   final snapshot = await usersRef.doc(_UID).get();
  //   if (snapshot.exists) {
  //     setState(() {
  //       _Total = snapshot.get('Total');
  //       _DateReservation = snapshot.get('DateReserva');
  //       _Type = snapshot.get('PayReserva');
  //       _SubAgency = snapshot.get('SubAgencyReserva');
  //       checkStatus = snapshot.get('ReservationStatus');
  //       print('checkStatus: $checkStatus');
  //     });
  //   }
  //   // }
  // }

  @override
  void initState() {
    // fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usersPIN').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final bool isAdminStatusTrue =
                  userData['ConditionCheckAgency'] == true &&
                      userData['ReservationStatus'] == true;
              if (isAdminStatusTrue) {
                final String _Total = userData['Total'];
                final String _DateReservation = userData['DateReserva'];
                final String _Type = userData['PayReserva'];
                final String _SubAgency = userData['SubAgencyReserva'];
                final String _UserFName = userData['FirstName'] ?? 'Null';
                final String _UserName = userData['LastName'] ?? 'Null';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text('$_UserFName $_UserName $_Total THB'),
                    subtitle:
                        Text('${_DateReservation}, ${_SubAgency}, ${_Type}'),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
