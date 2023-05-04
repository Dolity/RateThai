import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/curinfo2.dart';

class CurTest extends StatefulWidget {
  @override
  _CurTestState createState() => _CurTestState();
}

// class _CurTestState extends State<CurTest> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("List Agen Exchange TEST")),
//       body: ListView(
//         children: [
//           Card(
//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//               side: BorderSide(
//                 color: Colors.grey.shade300,
//                 width: 1, // Add a border
//               ),
//             ),
//             elevation: 8, // Add a shadow

//             child: InkWell(
//               onTap: () {
//                 // Do something when the ListTile is tapped
//               },
//               child: Container(
//                 child: ListTile(
//                   trailing: Icon(Icons.arrow_forward),
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => CurInfo2()));
//                   },
//                   contentPadding: EdgeInsets.only(left: 20, right: 20),
//                   dense: true,
//                   subtitle: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [

//                       FittedBox(
//                         fit: BoxFit.fill,
//                         child: Image.network(
//                             'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FUSD.png?alt=media&token=97b728ff-edcb-42f4-9b31-138298453e83'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
//                         child: Text(
//                           "USA",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _CurTestState extends State<CurTest> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Agen Exchange TEST")),
      body: ListView(
        children: [
          SizedBox(
            //Box1
            height: 150,
            child: Card(
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
                child: Container(
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CurInfo2()));
                    },
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    dense: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("getCurrency")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    final documentHeader = snapshot.data!.docs;
                                    final agencySPO = documentHeader[7]
                                        ["agency"]; //index document

                                    final curIndex0 = agencySPO[0]
                                        ["cur"]; //index agency with map[]
                                    final cur_SPO_USA = (curIndex0);

                                    return (Row(
                                      children: [
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FUSD.png?alt=media&token=97b728ff-edcb-42f4-9b31-138298453e83',
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          cur_SPO_USA,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ));
                                  }
                                }),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Row(children: [
                              Text(
                                "Denomination",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "Buying",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "Selling",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("getCurrency")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        final document = snapshot.data!.docs;
                                        final agencySPO = document[7]
                                            ["agency"]; //index document

                                        final dem1Index0 = agencySPO[0]
                                            ["dem1"]; //index agency with map[]
                                        final parsedDem1_SPO_USA = (dem1Index0);

                                        final buyIndex0 = agencySPO[0]
                                            ["buy"]; //index agency with map[]
                                        final parsedBuy_SPO_USA = (buyIndex0);

                                        final sellIndex0 = agencySPO[0]
                                            ["sell"]; //index agency with map[]
                                        final parsedSell_SPO_USA = (sellIndex0);

                                        return Row(
                                          children: [
                                            Text(
                                              parsedDem1_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 105),
                                            Text(
                                              parsedBuy_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 40),
                                            Text(
                                              parsedSell_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Divider(
            color: Colors.black,
          ),
          SizedBox(
            //Box1
            height: 150,
            child: Card(
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
                child: Container(
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CurInfo2()));
                    },
                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                    dense: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("getCurrency")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    final documentHeader = snapshot.data!.docs;
                                    final agencySPO = documentHeader[7]
                                        ["agency"]; //index document

                                    final curIndex0 = agencySPO[0]
                                        ["cur"]; //index agency with map[]
                                    final cur_SPO_USA = (curIndex0);

                                    return (Row(
                                      children: [
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FUSD.png?alt=media&token=97b728ff-edcb-42f4-9b31-138298453e83',
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          cur_SPO_USA,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ));
                                  }
                                }),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Row(children: [
                              Text(
                                "Denomination",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "Buying",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 30),
                              Text(
                                "Selling",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("getCurrency")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        final document = snapshot.data!.docs;
                                        final agencySPO = document[7]
                                            ["agency"]; //index document

                                        final dem1Index0 = agencySPO[0]
                                            ["dem1"]; //index agency with map[]
                                        final parsedDem1_SPO_USA = (dem1Index0);

                                        final buyIndex0 = agencySPO[0]
                                            ["buy"]; //index agency with map[]
                                        final parsedBuy_SPO_USA = (buyIndex0);

                                        final sellIndex0 = agencySPO[0]
                                            ["sell"]; //index agency with map[]
                                        final parsedSell_SPO_USA = (sellIndex0);

                                        return Row(
                                          children: [
                                            Text(
                                              parsedDem1_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 105),
                                            Text(
                                              parsedBuy_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 40),
                                            Text(
                                              parsedSell_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
