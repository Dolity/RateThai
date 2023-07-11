import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:testprojectbc/Service/singleton/userUID.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _idCardNumberController = TextEditingController();
  TextEditingController _idCardBackNumberController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  List<String> _days = List.generate(31, (index) => (index + 1).toString());
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> _years =
      List.generate(100, (index) => (2023 - index).toString());

  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  bool keepStatusAdmin = false;
  bool checkStatusAdmin = false;
  bool? isVerify = false;

  void verifyUser() {
    // โค้ดเพื่อทำการยืนยันตัวตนของผู้ใช้
    bool verificationSuccess =
        true; // ตั้งค่าเป็น true เมื่อการยืนยันตัวตนสำเร็จ
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop(
          verificationSuccess); // ส่งผลลัพธ์การยืนยันตัวตนกลับไปยังหน้า ReservationNav
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      UserSingleton().setUID(uid);
    }
    String? uid = UserSingleton().uid;
    print("Click UID: ${uid}");
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey,
                    ),
                    hintText: "ชื่อจริง",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _lastNameController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey,
                    ),
                    hintText: "นามสกุล",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 16),
              Text(
                'วันเกิด',
                style: GoogleFonts.nunitoSans(),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDay,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDay = newValue;
                        });
                      },
                      items: _days.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'วัน',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 150, // กำหนดความกว้างสูงสุดที่ต้องการ
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedMonth,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMonth = newValue;
                        });
                      },
                      items: _months.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'เดือน',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedYear = newValue;
                        });
                      },
                      items: _years.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                        labelText: 'ปี',
                        labelStyle:
                            GoogleFonts.nunitoSans(), // สีของข้อความ 'วัน'
                        floatingLabelBehavior:
                            FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                          borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'เพศ',
                style: GoogleFonts.nunitoSans(),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12, // สีพื้นหลังให้เป็นสีเทาอ่อน
                  labelText: 'เพศ',
                  labelStyle:
                      TextStyle(color: Colors.black), // สีของข้อความ 'วัน'
                  floatingLabelBehavior:
                      FloatingLabelBehavior.always, // ให้แสดงตลอดเวลา
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10), // กำหนดการแสดงผนัง
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30), // กำหนดรูปร่างเส้นขอบ
                    borderSide: BorderSide.none, // ไม่มีเส้นขอบ
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _idCardNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey,
                    ),
                    hintText: "เลขที่บัตรประชาชน",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _idCardBackNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey,
                    ),
                    hintText: "เลขเลเซอร์หลังบัตรประชาชน",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneNumberController,
                style: GoogleFonts.nunitoSans(),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    prefixIcon: Icon(
                      Ionicons.lock_closed_outline,
                      color: Colors.grey,
                    ),
                    hintText: "เบอร์โทรศัพท์",
                    hintStyle: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w600, color: Colors.black38),
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String? day = _selectedDay;
    String? month = _selectedMonth;
    String? year = _selectedYear;
    String? gender = _selectedGender;
    String idCardNumber = _idCardNumberController.text;
    String idCardBackNumber = _idCardBackNumberController.text;
    String phoneNumber = _phoneNumberController.text;

    // ควรใส่โค้ดที่จะส่งข้อมูลไปยัง API หรือบันทึกลงฐานข้อมูลตามที่คุณต้องการในส่วนนี้
    final user = FirebaseAuth.instance.currentUser!.uid;
    final usersRef = FirebaseFirestore.instance.collection('usersPIN');
    final data1 = usersRef.doc(user).get();
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await data1;

    if (snapshot.data() != null) {
      print('Updage data');
      usersRef.doc(user).update({
        'FirstName': '$firstName',
        'LastName': '$lastName',
        'DayofBirth': '$day',
        'MonthofBirth': '$month',
        'YearofBirth': '$year',
        'Gender': '$gender',
        'IDCardNumber': '$idCardNumber',
        'IDCardBackNumber': '$idCardBackNumber',
        'PhoneNumber': '$phoneNumber',
        'ReservationStatusAdmin': checkStatusAdmin,
        'ConditionCheckAdmin': keepStatusAdmin,
        'isVerify': isVerify,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Save to reservation on FireStoreSuccess! (Update)'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to save reservation on FireStoreSuccess!! (Update)'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    _clearFormFields();
  }

  void _clearFormFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _selectedDay = null;
    _selectedMonth = null;
    _selectedYear = null;
    _selectedGender = null;
    _idCardNumberController.clear();
    _idCardBackNumberController.clear();
    _phoneNumberController.clear();
  }
}
