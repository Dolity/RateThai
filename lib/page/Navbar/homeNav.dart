import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Setting/Theme.dart';
import '../login.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final authen = FirebaseAuth.instance;
  String usernameData = FirebaseAuth.instance.currentUser!.email!;
  final PageController _controller = PageController(initialPage: 0);
  final List<String> _tabs = ['1', '2'];
  int _selectedIndex = 0;
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('สวัสดีคุณ $usernameData'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authen.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }));
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => NotificationPage()),
            // );
          },
          child: const Icon(Icons.notifications),
          backgroundColor: Colors.blue,
          elevation: 4,
          shape: const CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: Theme(
          data: Styles.themeData(isDarkTheme, context),
          child: ListView(
            children: [
              SizedBox(
                width: 190,
                height: 180,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: PageView(
                          controller: _controller,
                          children: [
                            Image.network(
                              'https://www.superrichthailand.com/uploads/images/cd8811cfdce0375be9a599e6c19922f11669868861014.jpeg',
                              fit: BoxFit.cover,
                            ),
                            Image.network(
                              'https://superrichrate2.ztidev.com/superRich/download?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBlclJpY2giLCJleHAiOjQ4MzczNDM4MzUsImlhdCI6MTY4MTY0ODYzNSwia2V5IjoiajFTOHNkR3hyeHpKcnNad3NIU2NHd1BjIn0.biWX-uWdD01OXTnZBFL_GZJwqvwmRt0cs5-GB0kLRQY&file=4d46819f-b327-4db8-9740-da53feb28aeb1676947947227.jpg',
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            2,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                    _controller.animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 10,
                                  width: _selectedIndex == index ? 20 : 10,
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == index
                                        ? Colors.black
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
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
              const SizedBox(height: 10),
              const Divider(
                color: Colors.white,
              ),
              SizedBox(
                //Box1
                height: 210,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ListTile(
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => CurInfo2()));
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 20, right: 20),
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
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        final documentHeader =
                                            snapshot.data!.docs;
                                        if (documentHeader.length < 8) {
                                          return const Text('No data found');
                                        }
                                        final agencySPO = documentHeader[7]
                                            ["agency"]; //index document

                                        final curIndex0 = agencySPO[0]
                                            ["cur"]; //index agency with map[]
                                        final cur_SPO_USA = (curIndex0);

                                        return (Row(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Rate Thai",
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
                            Column(
                              children: [
                                Row(children: [
                                  const SizedBox(width: 0),
                                  Text(
                                    "ยอดเงินรวม",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
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
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            final document =
                                                snapshot.data!.docs;
                                            final agencySPO = document[7]
                                                ["agency"]; //index document

                                            final dem1Index0 = agencySPO[0][
                                                "dem1"]; //index agency with map[]
                                            final parsedDem1_SPO_USA =
                                                (dem1Index0);

                                            final buyIndex0 = agencySPO[0][
                                                "buy"]; //index agency with map[]
                                            final parsedBuy_SPO_USA =
                                                (buyIndex0);

                                            final sellIndex0 = agencySPO[0][
                                                "sell"]; //index agency with map[]
                                            final parsedSell_SPO_USA =
                                                (sellIndex0);

                                            return Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  child: Text(
                                                    "2500.24 THB",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                  ],
                                ),
                                const Divider(
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
                                        icon: const Icon(
                                            Icons.swap_horizontal_circle),
                                      ),
                                      preferBelow: false,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Tooltip(
                                      message: 'บริษัทแลกเงิน',
                                      child: IconButton(
                                        onPressed: () {
                                          // ทำอะไรเมื่อคลิก
                                        },
                                        icon: const Icon(Icons.account_balance),
                                      ),
                                      preferBelow: false,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Tooltip(
                                      message: 'แจ้งเตือนสกุลเงิน',
                                      child: IconButton(
                                        onPressed: () {
                                          // ทำอะไรเมื่อคลิก
                                        },
                                        icon: const Icon(Icons.notifications),
                                      ),
                                      preferBelow: false,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                //Box1
                height: MediaQuery.of(context).size.height * 1.0,
                width: MediaQuery.of(context).size.width * 1.0,

                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ListTile(
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => CurInfo2()));
                        },
                        contentPadding:
                            const EdgeInsets.only(left: 20, right: 20),
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
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        final documentHeader =
                                            snapshot.data!.docs;
                                        final agencySPO = documentHeader[7]
                                            ["agency"]; //index document

                                        final curIndex0 = agencySPO[0]
                                            ["cur"]; //index agency with map[]
                                        final cur_SPO_USA = (curIndex0);

                                        return (Row(
                                          children: [
                                            const Text(
                                              "Rate Thai - รายการล่าสุด",
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
                            Column(
                              children: [
                                Row(children: [
                                  const SizedBox(width: 0),
                                ]),
                                Row(
                                  children: [
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("getCurrency")
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            final document =
                                                snapshot.data!.docs;
                                            final agencySPO = document[7]
                                                ["agency"]; //index document

                                            final dem1Index0 = agencySPO[0][
                                                "dem1"]; //index agency with map[]
                                            final parsedDem1_SPO_USA =
                                                (dem1Index0);

                                            final buyIndex0 = agencySPO[0][
                                                "buy"]; //index agency with map[]
                                            final parsedBuy_SPO_USA =
                                                (buyIndex0);

                                            final sellIndex0 = agencySPO[0][
                                                "sell"]; //index agency with map[]
                                            final parsedSell_SPO_USA =
                                                (sellIndex0);

                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
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
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 0, 0),
                                                  child: Text(
                                                    "โอนเงิน/ชำระเงิน",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      40, 10, 0, 0),
                                                  child: Text(
                                                    "2500.00 THB",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          150, 0, 0, 0),
                                      child: Text(
                                        "15 เม.ย. 2566 - 17:25",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/logo%2FcropLOGO.png?alt=media&token=7d02630e-0171-4913-b942-6f53ae8b6bd4',
                                          fit: BoxFit.cover,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Text(
                                        "โอนเงิน/ชำระเงิน",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 0, 0),
                                      child: Text(
                                        "2500.00 THB",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(150, 0, 0, 0),
                                  child: Text(
                                    "15 เม.ย. 2566 - 17:25",
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
            ],
          ),
        ));
  }
}
