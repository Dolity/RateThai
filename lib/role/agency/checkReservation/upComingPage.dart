import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class UpComingPage extends StatefulWidget {
  @override
  _UpComingPageState createState() => _UpComingPageState();
}

class _UpComingPageState extends State<UpComingPage> {
  String? _Cur;
  String? _Total;
  String? _Type;
  String? _Rate;
  String? _DateReservation;
  String? _SubAgency;
  bool? checkStatus;
  bool? keepStatus;
  String qrCodeData = '';
  String? _UID;
  bool? dropOffStatus;

  // Future<void> fetchData() async {
  //   String? user = UserSingleton().uid;
  //   print('UserSingleton: $user');

  //   // บันทึกข้อมูลใน Firestore หาก user ไม่เป็น null
  //   //if (user != null) {
  //   // final usersRefUpdate = FirebaseFirestore.instance.collection('keepUID');
  //   // await usersRefUpdate.doc("pin").update({'uid': user});
  //   // print('UID Saved');

  //   // ดึงข้อมูลจาก Firestore ตามปกติ
  //   // final usersRef2 = FirebaseFirestore.instance.collection('usersPIN');
  //   // final snapshot = await usersRef2.doc(user).get();

  //   // if (snapshot.exists) {
  //   //   setState(() {
  //   //     // _Fname = snapshot.get('FirstName');
  //   //     // _Lname = snapshot.get('LastName');
  //   //     // _Gender = snapshot.get('Gender');
  //   //     _Total = snapshot.get('Total');
  //   //     _DateReservation = snapshot.get('DateReserva');
  //   //     _Type = snapshot.get('PayReserva');
  //   //     _SubAgency = snapshot.get('SubAgencyReserva');
  //   //     checkStatus = snapshot.get('ReservationStatus');
  //   //     keepStatus = snapshot.get('ConditionCheckAgency');
  //   //     // _UID = snapshot.get('UID');
  //   //   });
  //   // }
  //   //} else {
  //   print('User Null But Found UID ON FS');
  //   final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
  //   final snapshotGet = await usersRefGet.doc("pin").get();
  //   if (snapshotGet.exists) {
  //     setState(() {
  //       _UID = snapshotGet.get('uid');
  //     });
  //   }
  //   print('Click UID: $_UID');

  //   // ดึงข้อมูลจาก Firestore ด้วย _UID ที่ได้จาก Firestore ก่อนหน้า
  //   final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  //   final snapshot = await usersRef.doc(_UID).get();

  //   print('snapshotUpdate: $usersRef');
  //   if (snapshot.exists) {
  //     setState(() {
  //       // _Fname = snapshot.get('FirstName');
  //       // _Lname = snapshot.get('LastName');
  //       // _Gender = snapshot.get('Gender');
  //       _Total = snapshot.get('Total');
  //       _DateReservation = snapshot.get('DateReserva');
  //       _Type = snapshot.get('PayReserva');
  //       _SubAgency = snapshot.get('SubAgencyReserva');
  //       checkStatus = snapshot.get('ReservationStatus');
  //       keepStatus = snapshot.get('ConditionCheckAgency');
  //     });
  //   }
  //   // }
  // }

  @override
  void initState() {
    //fetchData();
    super.initState();
  }

  Future<void> updateUserData(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(uid).get();

    if (snapshot.exists) {
      setState(() {
        checkStatus = true;
        keepStatus = true;
        dropOffStatus = true;
        // isVerify = true;
      });

      if (snapshot.data()!['DateReserva'] != null ||
          snapshot.data()!['DateReserva'] == null) {
        usersRef.doc(uid).update({
          'ReservationStatus': checkStatus,
          'ConditionCheckAgency': keepStatus,
          // 'DropOffStatus': dropOffStatus,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Save to Status on Firestore Success! (Update)',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Failed to save Status on Firestore! (Update)',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Upcoming'),
      // ),
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
              final bool isAdminStatusFalse =
                  userData['ConditionCheckAgency'] == false &&
                      userData['ReservationStatus'] == false;

              if (isAdminStatusFalse) {
                return Card(
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
                                await updateUserData(userData['UID']);
                                Navigator.of(context).pop();
                              },
                              child: Text('Allow'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Not Allow'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.notification_important),
                      title: Text(
                          '${userData['FirstName'] ?? 'Null'} ${userData['LastName'] ?? 'Null'} ${userData['Total']} THB'),
                      subtitle: Text(
                          '${userData['DateReserva']}, ${userData['SubAgencyReserva']}, ${userData['PayReserva']}'),
                    ),
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
