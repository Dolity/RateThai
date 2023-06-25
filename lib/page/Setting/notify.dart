import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:provider/provider.dart';
// import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Setting/detailNotify.dart';
import 'package:testprojectbc/page/Setting/notifyAwesome.dart';
import 'package:testprojectbc/page/Setting/push_notification_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Service/provider/reservationData.dart';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';

class notify extends StatefulWidget {
  // final NotificationModel notification;
  // const notify({Key? key, required this.notification}) : super(key: key);
  notify({Key? key}) : super(key: key);

  _notify createState() => _notify();
}

class _notify extends State<notify> {
  String? mtoken = " ";
  bool _showIcon = false;
  String keepCur = "";
  String keepRate = "";
  String keepResevaProviRateUpdate = "";
  final user = FirebaseAuth.instance.currentUser!.uid;
  StreamSubscription<ReceivedAction>? _actionStreamSubscription;
  bool ckIsReservation = false;
  // void initState() {
  //   super.initState();
  //   NotificationService.initFirebaseMessaging(context);
  // }

  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification Created on ${notification.channelKey}',
        ),
      ));
    });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => PlantStatsPage(),
      //   ),
      //   (route) => route.isFirst,
      // );
    });
  }

  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  Future<List<DocumentSnapshot<Object?>>> fetchDatausersPIN() async {
    final usersRefD1 = FirebaseFirestore.instance.collection('usersPIN');
    final data1 = await usersRefD1.doc(user).get();

    final usersRefD2 = FirebaseFirestore.instance.collection('getCurrency');
    final data2 = await usersRefD2.doc(user).get();

    return [data1, data2];
  }

  Future<List<QuerySnapshot>> fetchDatagetCurrency() async {
    final usersRefD2 = FirebaseFirestore.instance.collection('getCurrency');
    final data2 = await usersRefD2.get();

    return [data2];
  }

  Widget build(BuildContext context) {
    keepCur = context.watch<ReservationData>().notifyCur.toString();
    keepRate = context.watch<ReservationData>().notifyRate.toString();
    keepResevaProviRateUpdate =
        context.watch<ReservationData>().resevaProviRateUpdate.toString();

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
        child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
          future: fetchDatausersPIN(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot<Object?>>> snapshot) {
            // final data = snapshot.data?.data() as Map<String, dynamic>?;
            fetchDatagetCurrency();
            final data1 = snapshot.data?[0];

            // if (data1?['RateNoti'] == keepRate &&
            //     data1?['CurrencyNoti'] == keepCur) {
            //   // NotificationService.showNotification(
            //   //   title: 'Rate alert',
            //   //   body: '1 $keepCur = $keepResevaProviRateUpdate THB',
            //   // );
            //   createReservationPositiveNotification(context);
            // }

            if (data1?['RateNoti'] != null && data1?['CurrencyNoti'] != null) {
              // keepCur
              double previousRate =
                  double.parse(data1?['RateNoti']); //Rate from User set
              double currentRate =
                  double.parse(keepRate); //Rate from agency Scarping

              if (currentRate > previousRate) {
                // แจ้งเตือนว่าราคาสกุลเงินขึ้น
                createReservationPositiveNotification(context);
              } else if (currentRate < previousRate) {
                // แจ้งเตือนว่าราคาสกุลเงินลง
                createReservationNegativeNotification(context);
              }
            }

            print('Provider: $keepRate, $keepCur');

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (data1?['RateNoti'] == null) {
              print('No data!');
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              print("Return: Widget!");

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
                                                                '1 ${data1?['CurrencyNoti']} = ${data1?['RateNoti']} THB',
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