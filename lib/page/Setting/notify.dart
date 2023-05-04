import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Setting/detailNotify.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:testprojectbc/main.dart';
// import 'package:testprojectbc/page/Setting/notifyService.dart';
import 'package:testprojectbc/page/Setting/push_notification_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class notify extends StatefulWidget {
  final NotificationModel notification;
  const notify({Key? key, required this.notification}) : super(key: key);

  _notify createState() => _notify();
}

class _notify extends State<notify> {
  String? mtoken = " ";
  bool _showIcon = false;
  final user = FirebaseAuth.instance.currentUser!.uid;

  void initState() {
    super.initState();
    NotificationService.initFirebaseMessaging(context);
  }

  Future<DocumentSnapshot> fetchData() async {
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    return await usersRef.doc(user).get();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DetailNotifyPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        elevation: 4,
        shape: CircleBorder(),
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: fetchData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            final data = snapshot.data?.data() as Map<String, dynamic>?;
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (data?['RateNoti'] == null) {
              print('No data!');
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              print("Return: Widget!");

              if (data?['RateNoti'] == '100' && data?['CurrencyNoti'] == 'USD') {
                log("Show alert");
                NotificationService.showNotification(
                  title: 'Rate alert',
                  body: '1 USD = 100 THB',
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    child: SizedBox(
                        //Box1
                        height: 80,
                        width: MediaQuery.of(context).size.width * 1.0,
                        child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1, // Add a border
                              ),
                            ),
                            elevation: 8, // Add a shadow
                            child: InkWell(
                                onTap: () {
                                  // NotificationService.showNotification(
                                  //   title: 'Rate alert',
                                  //   body: ' 1 ${data?['CurrencyNoti']} = ${data?['RateNoti']} THB',
                                  // );
                                },
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                5, 15, 0, 15),
                                            child: Icon(
                                              FontAwesomeIcons.bell,
                                              size: 30,
                                            )),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 0, 15),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'You will get an alert ',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: ' ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '1 ${data?['CurrencyNoti']} = ${data?['RateNoti']} THB',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]))
                                      ],
                                    ))))),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}


  // void initState() {
  //   super.initState();
  //   getToken();
  //   NotificationService.initFirebaseMessaging(context);
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       mtoken = token;
  //       print("My Token is: $mtoken");
  //     });
  //     saveToken(token!);
  //   });
  // }

  // void saveToken(String token) async {
  //   await FirebaseFirestore.instance.collection("users").doc("User1").set({
  //     'token': token,
  //   });
  // }


                

  // @override
  // void initState() {
  //   super.initState();
  //   requestPermission();
  //   getToken();
  //   //initInfo();

  // }

  // initInfo() {
  //   const AndroidInitializationSettings androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   //const iOSInitializationSettings iosInitialize = IOSInitializationSettings();
  //   const InitializationSettings initializationsSettings = InitializationSettings(android: androidInitialize);

  //   flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async {
  //     try {
  //       if (payload != null && payload.isNotEmpty) {
  //         // Handle notification payload here
  //       } else {
  //         // Handle notification when tapped without payload here
  //       }
  //     } catch (e) {
  //       // Handle error here
  //       return;
  //     }
  //   });
  // }

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //     print('User Granted provisional Permission');
  //   } else {
  //     print('User declined or has not accept permission');
  //   }
  // }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: username,
//             ),
//             TextFormField(
//               controller: title,
//             ),
//             TextFormField(
//               controller: body,
//             ),
//             GestureDetector(
//               onTap: () async {
//                 String name = username.toString().trim();
//                 String titleText = title.text;
//                 String bodyText = body.text;
//               },
//               child: Container(
//                 margin: const EdgeInsets.all(20),
//                 height: 40,
//                 width: 200,

//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.redAccent.withOpacity(0.5),
//                     )
//                   ]
//                 ),
//                 child: Center(child: Text("Button")),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }