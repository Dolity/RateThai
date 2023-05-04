import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/curinfo2.dart';

class CurInfo extends StatefulWidget {
  @override
  _CurInfoState createState() => _CurInfoState();
}

class _CurInfoState extends State<CurInfo> {
  String? imageUrl;

  Future<void> downloadImage() async {
    // Create a reference to the image in Firebase Storage

    final ref = FirebaseStorage.instance.ref().child('IMG_Currency/JPY.png');
    print('ref URL: $ref');
    try {
      // Download the image and get the download URL
      final downloadUrl = await ref.getDownloadURL();

      // Update the state to show the image
      setState(() {
        imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    downloadImage();
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("List Agen Exchange")),
  //     body: StreamBuilder(
  //       stream:
  //           FirebaseFirestore.instance.collection("getCurrency").snapshots(),
  //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         } else {
  //           return ListView.separated(
  //             separatorBuilder: (context, index) => Divider(),
  //             itemCount: snapshot.data!.docs.length,
  //             itemBuilder: (context, index) {
  //               final document = snapshot.data!.docs[index];

  //               return InkWell(
  //                 onTap: () {
  //                   // Do something when the ListTile is tapped
  //                 },
  //                 child: Container(
  //                   child: ListTile(
  //                     leading: CircleAvatar(
  //                       // backgroundColor: Colors.amberAccent,
  //                       //backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FUSD.png?alt=media&token=97b728ff-edcb-42f4-9b31-138298453e83'),
  //                       backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
  //                       radius: 30,
  //                       child: FittedBox(
  //                         child: Text(document["agenName"] ?? ""),
  //                       ),
  //                     ),
  //                     title: Text(document["DateTimeUpdate"] ?? ""),
  //                     trailing: Icon(Icons.arrow_forward),
  //                     onTap: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => CurInfo2()));
  //                     },
  //                     contentPadding: EdgeInsets.only(left: 20, right: 20),
  //                     dense: true,
  //                     tileColor: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8)),
  //                     subtitle: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         ListTile(
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           title: Text(
  //                             "Currency: ${document["agency"][0]["cur"]}",
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                         ListTile(
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           title: Text(
  //                             "Buy rate: ${document["agency"][0]["buy"]}",
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                         ListTile(
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           title: Text(
  //                             "Sell rate: ${document["agency"][0]["sell"]}",
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                         ListTile(
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           title: Text(
  //                             "dem1: ${document["agency"][0]["dem1"]}",
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                         ListTile(
  //                           dense: true,
  //                           contentPadding: EdgeInsets.zero,
  //                           title: Text(
  //                             "dem2: ${document["agency"][0]["dem2"]}",
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Agen Exchange")),
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
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade500,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1, // Add a border
                    ),
                  ),
                  elevation: 8, // Add a shadow

                  child: InkWell(
                    onTap: () {
                      // Do something when the ListTile is tapped
                    },
                    child: ListTile(
                      // leading: CircleAvatar(
                      // backgroundImage:

                      // radius: 20,

                      // ),

                      
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CurInfo2()));
                      },
                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                      dense: true,
                      //  tileColor: Colors.g,
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(8)),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(imageUrl!),
                
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                            child: Text(
                              "USA",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Divider(),

                          // ListTile(
                          //   dense: true,
                          //   contentPadding: EdgeInsets.zero,
                          //   title: Text(
                          //     "Sell rate: ${document["agency"][0]["sell"]}",
                          //     style: TextStyle(fontSize: 12),
                          //   ),
                          // ),

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
