import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurInfo2 extends StatefulWidget {
  @override
  _CurInfoState2 createState() => _CurInfoState2();
}

class _CurInfoState2 extends State<CurInfo2> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Current")),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("getCurrency").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];

                
                return InkWell(
                  onTap: () {
                    // Do something when the ListTile is tapped
                  },
                  child: Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text(document["agenName"] ?? ""),
                        ),
                      ),
                      title: Text(document["DateTimeUpdate"] ?? ""),
                      trailing: Icon(Icons.currency_exchange_sharp),
                      onTap: () {

                      },
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      dense: true,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Currency: ${document["agency"][0]["cur"]}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Buy rate: ${document["agency"][0]["buy"]}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "Sell rate: ${document["agency"][0]["sell"]}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "dem1: ${document["agency"][0]["dem1"]}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              "dem2: ${document["agency"][0]["dem2"]}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
