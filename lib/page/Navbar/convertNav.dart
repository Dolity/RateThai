import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:testprojectbc/models/notifyModel.dart';
import 'package:testprojectbc/page/Setting/notify.dart';
import 'package:http/http.dart' as http;

class CalculatorNav extends StatefulWidget {
  @override
  _CalculatorNavState createState() => _CalculatorNavState();
}

class _CalculatorNavState extends State<CalculatorNav> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _currencies = ['AED', 'AUD', 'BHD', 'BND', 'CAD', 'CHF', 'CNY', 'DKK', 'EUR', 'GBP', 
    'HKD', 'IDR', 'INR', 'JOD', 'JPY', 'KRW', 'KWD','LAK', 'MMK', 'MOP', 'MYR', 'NOK', 'NPR', 'NZD', 
    'OMR', 'PHP', 'QAR', 'RUB', 'SAR', 'SEK', 'SGD', 'TRY', 'TWD','USD', 'VND', 'ZAR'];
  String? _fromCurrency = 'USD';
  String? _toCurrency = 'THB';
  String? _agenName = '';
  double? _exchangeRate = 0.0;

  double? maxSellRate = 0.0;
  String? maxSellRateAgen = '';
  var highestSellRate = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Currency Converter'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => notify(
                  notification: NotificationModel(amount: '', fromCurrency: ''),
                ),
              ),
            );
          },
          child: Icon(Icons.notifications),
          backgroundColor: Colors.blue,
          elevation: 4,
          shape: CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        body: ListView(children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                SizedBox(
                    width: 350,
                    height: 335,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DropdownButton<String>(
                                        value: _fromCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _fromCurrency = value;
                                            print(
                                                'fromCurrency: $_fromCurrency');
                                          });
                                        },
                                        items: _currencies
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward_ios),
                                        onPressed: () {
                                        },
                                      ),
                                      DropdownButton<String>(
                                        value: _toCurrency,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _toCurrency = value;
                                            print('toCurrency: $_toCurrency');
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('THB'),
                                            value: 'THB',
                                          ),
                                          // Add more currencies here
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: _textEditingController,
                                    validator: RequiredValidator(
                                        errorText: "กรุณาใส่ค่าตัวเลข"),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: '0.00',
                                        hintStyle: TextStyle(fontSize: 30)),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () async {
                                      highestSellRate = 0.0;
                                      var message = "";
                                      message = "กรุณาใส่ค่าตัวเลข";
                                      if (_textEditingController.text.isEmpty) {
                                        setState(() {
                                          _exchangeRate = 0.0;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                        print('Error: Please enter amount');
                                        return;
                                      } else {
                                        //var apiKey = 'e50a59e299ef0bae5bc03139';
                                        var url =
                                            //'https://v6.exchangerate-api.com/v6/$apiKey/latest/$_fromCurrency';
                                            'http://192.168.0.104:5100/getagencies/$_fromCurrency';
                                        var response =
                                            await http.get(Uri.parse(url));
                                        print('before response');
                                        if (response.statusCode == 200) {
                                          print('if response OK');

                                          var jsonResponse = jsonDecode(response.body);
                                          print(jsonResponse);
                                          if (jsonResponse is List && jsonResponse.isNotEmpty) {
                                            var agencies = jsonResponse;
                                            var conversionMap = Map<String, dynamic>();
                                            for (var agency in agencies) {
                                              if (agency is Map && agency.containsKey('agency') && agency is Map && agency.containsKey('agenName')) {
                                                var agencyData = agency['agency'];

                                                var agenName = agency['agenName'];

                                                if (agencyData is List && agencyData.isNotEmpty) {
                                                  for (var data in agencyData) {
                                                    if (data is Map && data.containsKey('cur') && data.containsKey('sell')) {

                                                      String currency = data['cur'];
                                                      double sellRate = double.parse(data['sell']);
                                                      conversionMap[currency] = {'agenName': agenName, 'sellRate': sellRate};  // เพิ่ม agenName ลงใน conversionMap พร้อมกับ sellRate
                                                      print("Agen: $agenName // Cur: $currency // Sell: $sellRate");

                                                      for (var entry in conversionMap.entries) {
                                                        var currency = entry.key;
                                                        var value = entry.value;
                                                        var agenName = value['agenName'];
                                                        var sellRate = value['sellRate'];

                                                        if (sellRate > highestSellRate) {
                                                          highestSellRate = sellRate; // update the highest sell rate if a higher value is found
                                                          maxSellRateAgen = agenName; // update the agenName with the highest sell rate
                                                        }
                                                      }
                                                      


                                                      setState(() {

                                                        _exchangeRate = highestSellRate; // เอาค่า sellRate จาก conversionMap
                                                        print('Agen name: $agenName');
                                                        print('Sell rate: $sellRate');
                                                      
                                                        print('Invalid currency');
                                                      
                                                      });
                                                    }
                                                  }
                                                  
                                            }
                                          } else {
                                            print('Invalid JSON data');
                                          }
                            }
                              }
                              print('Max sell rate Agen name: $maxSellRateAgen // HighestSell: $highestSellRate');
                                }
                                  }
                                    },
                                    child: Text(
                                      'คำนวณอัตราแลกเปลี่ยนสกุลเงิน',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 16),
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Exchange rate: $_exchangeRate',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Result: ${((_exchangeRate ?? 0.0) * (double.tryParse(_textEditingController?.text?.toString() ?? '0.0') ?? 0.0)).toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ])))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: SizedBox(
                      //Box1
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
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
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: SizedBox(
                      //Box1
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: Card(
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
                          ))),
                ),
              ])),
        ]));
  }
}

