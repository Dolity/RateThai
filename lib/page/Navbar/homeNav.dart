import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:testprojectbc/page/Setting/verifyKYC.dart';
import '../Setting/Theme.dart';
import '../login.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

bool _isNotifyStatusProcessed = false;

class _HomeNavState extends State<HomeNav> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  final authen = FirebaseAuth.instance;
  late User? currentUser;
  String usernameData = "";
  late String userUID; //getByUID

  final PageController _controller = PageController(initialPage: 0);
  final List<String> _tabs = ['1', '2'];
  int _selectedIndex = 0;
  String keepCur = "";
  String keepRate = "";
  String keepResevaProviRateUpdate = "";
  String _UID = "";
  String Fname = "";
  String Lname = "";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    currentUser = authen.currentUser;
    if (currentUser != null) {
      usernameData = currentUser!.email ?? "";
      userUID = currentUser!.uid;
    }
    _registerFirebaseMessagingToken();
  }

  void _registerFirebaseMessagingToken() {
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');

      final usersRef = FirebaseFirestore.instance.collection('usersPIN');
      usersRef.doc(userUID).update(
        {
          'FCMToken': token,
        },
      );
      print('FCM Token Update On FS: $token');
    }).catchError((error) {
      print('Failed to get FCM token: $error');
    });
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  void sendNotificationForegroundAwesomeKYC() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Verification KYC',
        body: 'You have been approved for verification.',
      ),
      schedule: NotificationCalendar(),
    );
  }

  void sendNotificationForegroundAwesomeReserve() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Currency Reservation',
        body: 'You have been approved for Currency Reservation.',
      ),
      schedule: NotificationCalendar(),
    );
  }

  void sendNotificationForegroundAwesomeReceive() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Currency Received',
        body: 'You have received money from the Agency.',
      ),
      schedule: NotificationCalendar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => notify(),
            ),
          );
        },
        child: Icon(Icons.notifications),
        backgroundColor: Colors.black,
        elevation: 4,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usersPIN')
            .where('UID', isEqualTo: userUID) //getByUID
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data!.docs;

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/bgnavHome2.jpg'), // เพิ่มรูปภาพที่ต้องการ
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final bool isAdminStatusTrue = userData['isVerify'] == true;
                final bool isDropOffStatus = userData['DropOffStatus'] == true;
                final bool isCheckAgencyStatus =
                    userData['ConditionCheckAgency'] == true;
                final bool isCheckAdminStatus = userData['isVerify'] == true;
                final bool isNotifyStatus = userData['isNotifyLocal'] == true;

                if (userData.isNotEmpty) {
                  if (isNotifyStatus && !_isNotifyStatusProcessed) {
                    sendNotificationForegroundAwesomeKYC();
                  }

                  if (isCheckAgencyStatus && !_isNotifyStatusProcessed) {
                    Future.delayed(Duration(seconds: 5), () {
                      sendNotificationForegroundAwesomeReserve();
                    });
                  }

                  if (isDropOffStatus && !_isNotifyStatusProcessed) {
                    Future.delayed(Duration(seconds: 10), () {
                      sendNotificationForegroundAwesomeReceive();
                    });
                  }
                  _isNotifyStatusProcessed = true;
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Rate Thai",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: GestureDetector(
                          //     // onTap: () {
                          //     //   print('google');
                          //     //   loginWithGoogle(context);
                          //     // },
                          //     child: Align(
                          //       alignment: Alignment.topRight,
                          //       child: IconButton(
                          //         icon: const Icon(Icons.logout),
                          //         onPressed: () {
                          //           authen.signOut().then((value) {
                          //             Navigator.pushReplacement(context,
                          //                 MaterialPageRoute(builder: (context) {
                          //               return LoginPage();
                          //             }));
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 390,
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  if (details.delta.dx > 0) {
                                    _selectedIndex = (_selectedIndex + 1) %
                                        2; // เปลี่ยนภาพไปยังภาพถัดไปเมื่อลากไปทางขวา
                                  } else if (details.delta.dx < 0) {
                                    _selectedIndex = (_selectedIndex - 1) %
                                        2; // เปลี่ยนภาพไปยังภาพก่อนหน้าเมื่อลากไปทางซ้าย
                                  }
                                  _controller.animateToPage(
                                    _selectedIndex,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              },
                              child: AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                left: -_selectedIndex *
                                    390, // เลื่อนภาพด้วยการกำหนดตำแหน่งซ้ายที่ติดลบ
                                child: PageView.builder(
                                  controller: _controller,
                                  itemCount: 2,
                                  itemBuilder: (context, index) => ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      index == 0
                                          ? 'https://www.superrichthailand.com/uploads/images/cd8811cfdce0375be9a599e6c19922f11669868861014.jpeg'
                                          : 'https://superrichrate2.ztidev.com/superRich/download?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBlclJpY2giLCJleHAiOjQ4MzczNDM4MzUsImlhdCI6MTY4MTY0ODYzNSwia2V5IjoiajFTOHNkR3hyeHpKcnNad3NIU2NHd1BjIn0.biWX-uWdD01OXTnZBFL_GZJwqvwmRt0cs5-GB0kLRQY&file=4d46819f-b327-4db8-9740-da53feb28aeb1676947947227.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10.0,
                              left: 0.0,
                              right: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  2,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index;
                                          _controller.animateToPage(
                                            index,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        height: 10,
                                        width:
                                            _selectedIndex == index ? 20 : 10,
                                        decoration: BoxDecoration(
                                          color: _selectedIndex == index
                                              ? Colors.black
                                              : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(height: 0),
                    SizedBox(
                      height: 170,
                      child: Card(
                        color:
                            Color.fromARGB(0, 255, 255, 255).withOpacity(0.8),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        elevation: 8,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: ListTile(
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerificationPage()));
                              },
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              dense: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hi 👋🏻",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              if (isAdminStatusTrue)
                                                Text(
                                                  "${userData['FirstName']} ${userData['LastName']} ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (isAdminStatusTrue == false)
                                                Text(
                                                  "Plsease Verify KYC ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (isAdminStatusTrue)
                                                Text(
                                                  "is Verify ✅",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (!isAdminStatusTrue)
                                                Text(
                                                  "is not Verify ❌",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Tooltip(
                                        message: 'แลกเงิน',
                                        child: IconButton(
                                          onPressed: () {
                                            // ทำอะไรเมื่อคลิก
                                          },
                                          icon: Icon(
                                              Icons.swap_horizontal_circle),
                                        ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Tooltip(
                                        message: 'บริษัทแลกเงิน',
                                        child: IconButton(
                                          onPressed: () {
                                            // ทำอะไรเมื่อคลิก
                                          },
                                          icon: Icon(Icons.account_balance),
                                        ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Tooltip(
                                        message: 'แจ้งเตือนสกุลเงิน',
                                        child: IconButton(
                                          onPressed: () {
                                            // ทำอะไรเมื่อคลิก
                                          },
                                          icon: Icon(Icons.notifications),
                                        ),
                                        preferBelow: false,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      //Box1
                      height: MediaQuery.of(context).size.height - 490,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
                        color:
                            Color.fromARGB(0, 255, 255, 255).withOpacity(0.8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                            // Do something when the ListTile is tapped
                          },
                          child: Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ListTile(
                                    trailing: Icon(Icons.arrow_forward),
                                    onTap: () {
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) => CurInfo2()));
                                    },
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    dense: true,
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Rate Thai - latest Status",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(children: [
                                              SizedBox(width: 0),
                                            ]),
                                            if (isDropOffStatus)
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 0, 0),
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                        fit: BoxFit.cover,
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 0),
                                                    child: Text(
                                                      "Receive Money ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            90, 10, 0, 0),
                                                    child: Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (isDropOffStatus)
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            240, 0, 0, 0),
                                                    child: Text(
                                                      "Status",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (!isDropOffStatus)
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 0, 0),
                                                    child: ClipOval(
                                                      child: Image.network(
                                                        'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                        fit: BoxFit.cover,
                                                        height: 40,
                                                        width: 40,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 0),
                                                    child: Text(
                                                      "Receive Money ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            50, 10, 0, 0),
                                                    child: Text(
                                                      "In Progress...",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (!isDropOffStatus)
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            240, 0, 0, 0),
                                                    child: Text(
                                                      "Status",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade500,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0,
                                            ),
                                            Column(
                                              children: [
                                                Row(children: [
                                                  SizedBox(width: 0),
                                                ]),
                                                if (isCheckAgencyStatus)
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0),
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                            fit: BoxFit.cover,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: Text(
                                                          "Reserve Money ",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                90, 10, 0, 0),
                                                        child: Text(
                                                          "Accept",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (isCheckAgencyStatus)
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                240, 0, 0, 0),
                                                        child: Text(
                                                          "Status",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (!isCheckAgencyStatus)
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0),
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                            fit: BoxFit.cover,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: Text(
                                                          "Reserve Money ",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                50, 10, 0, 0),
                                                        child: Text(
                                                          "In Progress...",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (!isCheckAgencyStatus)
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                240, 0, 0, 0),
                                                        child: Text(
                                                          "Status",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0,
                                            ),
                                            Column(
                                              children: [
                                                Row(children: [
                                                  SizedBox(width: 0),
                                                ]),
                                                if (isCheckAdminStatus)
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0),
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                            fit: BoxFit.cover,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: Text(
                                                          "Verify Account(KYC) ",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                58, 10, 0, 0),
                                                        child: Text(
                                                          "Accept",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (isCheckAdminStatus)
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                240, 0, 0, 0),
                                                        child: Text(
                                                          "Status",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (!isCheckAdminStatus)
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0),
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                            fit: BoxFit.cover,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: Text(
                                                          "Verify Account(KYC) ",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 0, 0),
                                                        child: Text(
                                                          "In Progress...",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                if (!isCheckAdminStatus)
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                240, 0, 0, 0),
                                                        child: Text(
                                                          "Status",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade500,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
