import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testprojectbc/Service/global/dataGlobal.dart' as globals;
import 'package:flutter/material.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
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
        title: Text('Completed'),
      ),
      body: Column(
        children: [
          if (checkStatus == true)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('${_Cur}'),
                subtitle: Text('${_Total}'),
              ),
            ),
          if (checkStatus == false)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.cancel),
                title: Text('${_Cur}'),
                subtitle: Text('${_Total}'),
              ),
            ),
        ],
      ),
    );
  }
}
