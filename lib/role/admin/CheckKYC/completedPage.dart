import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class CompletedAdminPage extends StatefulWidget {
  @override
  _CompletedAdminPageState createState() => _CompletedAdminPageState();
}

class _CompletedAdminPageState extends State<CompletedAdminPage> {
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
                  userData['ConditionCheckAdmin'] == true &&
                      userData['ReservationStatusAdmin'] == true;
              if (isAdminStatusTrue) {
                final String firstName = userData['FirstName'];
                final String lastName = userData['LastName'];
                final String gender = userData['Gender'];
                final String dayOfBirth = userData['DayofBirth'];
                final String monthOfBirth = userData['MonthofBirth'];
                final String yearOfBirth = userData['YearofBirth'];
                final String idCardNumber = userData['IDCardNumber'];
                final String phoneNumber = userData['PhoneNumber'];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle),
                    title: Text('$firstName $lastName ($gender)'),
                    subtitle: Text(
                        '$dayOfBirth:$monthOfBirth:$yearOfBirth, $idCardNumber, $phoneNumber'),
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
