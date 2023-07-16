// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testprojectbc/page/Reservation/reservaServices.dart';
import 'package:testprojectbc/screen/detailBlockchain.dart';

class testBC extends StatefulWidget {
  const testBC({Key? key}) : super(key: key);

  @override
  State<testBC> createState() => _testBCState();
}

class _testBCState extends State<testBC> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<NotesServices>();
    print(notesServices.notes);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data in Ethereum Sepolia Testnet'),
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
                  return ListTile(
                    title: Text(
                        '${notesServices.notes[index].firstnameBC} ${notesServices.notes[index].lastnameBC} (${notesServices.notes[index].genderBC})'),
                    subtitle: Text(
                        '${notesServices.notes[index].agencyBC} ${notesServices.notes[index].rateBC} ${notesServices.notes[index].currencyBC}, ${notesServices.notes[index].totalBC} THB, ${notesServices.notes[index].dateBC} '),
                    leading: Icon(Icons.remove_red_eye_outlined),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        notesServices.deleteNote(notesServices.notes[index].id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBCPage(
                            firstnameBC: notesServices.notes[index].firstnameBC,
                            lastnameBC: notesServices.notes[index].lastnameBC,
                            genderBC: notesServices.notes[index].genderBC,
                            agencyBC: notesServices.notes[index].agencyBC,
                            rateBC: notesServices.notes[index].rateBC,
                            currencyBC: notesServices.notes[index].currencyBC,
                            totalBC: notesServices.notes[index].totalBC,
                            dateBC: notesServices.notes[index].dateBC,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
