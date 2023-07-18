// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:testprojectbc/screen/detailBlockchain.dart';

class testBCUser extends StatefulWidget {
  const testBCUser({Key? key}) : super(key: key);

  @override
  State<testBCUser> createState() => _testBCUser();
}

class _testBCUser extends State<testBCUser> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late Map<String, dynamic> snapshotData;

  void getUIDonFS() async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final snapshot = await usersRef.doc(userUID).get();
    setState(() {
      snapshotData = snapshot.data() as Map<String, dynamic>;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  void initState() {
    getUIDonFS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<NotesServices>();
    print(notesServices.notes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Reservation'),
      ),
      body: notesServices.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await notesServices.fetchNotes();
              },
              child: ListView.builder(
                itemCount: notesServices.notes.length,
                itemBuilder: (context, index) {
                  final note = notesServices.notes[index];

                  if (note.firstnameBC == snapshotData['FirstName']) {
                    print(
                        'conditionCheck : ${note.firstnameBC}, ${snapshotData['FirstName']}');
                    return ListTile(
                      title: Text(
                          '${notesServices.notes[index].firstnameBC} ${notesServices.notes[index].lastnameBC} (${notesServices.notes[index].genderBC})'),
                      subtitle: Text(
                          '${notesServices.notes[index].agencyBC} ${notesServices.notes[index].rateBC} ${notesServices.notes[index].amountBC} ${notesServices.notes[index].currencyBC}, ${notesServices.notes[index].totalBC} THB, ${notesServices.notes[index].dateBC} '),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBCPage(
                              firstnameBC:
                                  notesServices.notes[index].firstnameBC,
                              lastnameBC: notesServices.notes[index].lastnameBC,
                              genderBC: notesServices.notes[index].genderBC,
                              agencyBC: notesServices.notes[index].agencyBC,
                              rateBC: notesServices.notes[index].rateBC,
                              currencyBC: notesServices.notes[index].currencyBC,
                              totalBC: notesServices.notes[index].totalBC,
                              dateBC: notesServices.notes[index].dateBC,
                              amountBC: notesServices.notes[index].amountBC,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
    );
  }
}
