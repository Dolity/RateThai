import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class UpComingAdminPage extends StatefulWidget {
  @override
  _UpComingAdminPageState createState() => _UpComingAdminPageState();
}

class _UpComingAdminPageState extends State<UpComingAdminPage> {
  String? _UID;
  String? Fname;
  String? Lname;
  String? Gender;
  String? dayBirth;
  String? monthBirth;
  String? yearBirth;
  String? idCard;
  String? phoneNumber;
  bool? checkStatusAdmin;
  bool? keepStatusAdmin;
  bool? isVerify = false;

  // Future<void> fetchData() async {
  //   final usersRefGet = FirebaseFirestore.instance.collection('keepUID');
  //   final snapshotGet = await usersRefGet.doc("pin").get();
  //   if (snapshotGet.exists) {
  //     setState(() {
  //       _UID = snapshotGet.get('uid');
  //     });
  //   }

  //   final usersRef = FirebaseFirestore.instance.collection('usersPIN');
  //   final snapshot = await usersRef.doc(_UID!).get();

  //   if (snapshot.exists) {
  //     setState(() {
  //       Fname = snapshot.get('FirstName');
  //       Lname = snapshot.get('LastName');
  //       Gender = snapshot.get('Gender');
  //       dayBirth = snapshot.get('DayofBirth');
  //       monthBirth = snapshot.get('MonthofBirth');
  //       yearBirth = snapshot.get('YearofBirth');
  //       idCard = snapshot.get('IDCardNumber');
  //       phoneNumber = snapshot.get('PhoneNumber');
  //       checkStatusAdmin = snapshot.get('ReservationStatusAdmin');
  //       keepStatusAdmin = snapshot.get('ConditionCheckAdmin');
  //     });
  //   }
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
        checkStatusAdmin = true;
        keepStatusAdmin = true;
        isVerify = true;
      });

      if (snapshot.data()!['DateReserva'] != null ||
          snapshot.data()!['DateReserva'] == null) {
        usersRef.doc(uid).update({
          'ReservationStatusAdmin': checkStatusAdmin,
          'ConditionCheckAdmin': keepStatusAdmin,
          'isVerify': isVerify,
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
      appBar: AppBar(
        title: Text('Upcoming'),
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
              final bool isAdminStatusFalse =
                  userData['ConditionCheckAdmin'] == false &&
                      userData['ReservationStatusAdmin'] == false;
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
                          content:
                              Text('คุณต้องการยืนยันตัวตนบุคคลนี้ใช่หรือไม่?'),
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
                      // leading: checkStatusAdmin!
                      //     ? Icon(Icons.check_circle)
                      // : Icon(Icons.notification_important),
                      leading: Icon(Icons.notification_important),
                      title: Text(
                          '${userData['FirstName']} ${userData['LastName']} (${userData['Gender']})'),
                      subtitle: Text(
                          '${userData['DayofBirth']}:${userData['MonthofBirth']}:${userData['YearofBirth']}, ${userData['IDCardNumber']}, ${userData['PhoneNumber']}'),
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
