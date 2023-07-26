import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckURLPage extends StatefulWidget {
  @override
  _CheckURLPageState createState() => _CheckURLPageState();
}

class _CheckURLPageState extends State<CheckURLPage> {
  List<String> urls = [];
  Map<String, bool> _canAccessURLs = {};

  @override
  void initState() {
    super.initState();
    fetchUrlsFromFirestore();
  }
  //k79exchange
  //siamexchange
  //superrichthailand
  //superrich1965
  //valueplusexchange
  //vasuexchange
  //x-one

  void fetchUrlsFromFirestore() async {
    try {
      await Firebase.initializeApp();
      final firestoreURL = FirebaseFirestore.instance.collection('keepUID');
      final snapshotURL = await firestoreURL.doc('pin').get();
      if (snapshotURL.exists) {
        setState(() {
          String urlK79 = snapshotURL.get('urlK79');
          String urlSME = snapshotURL.get('urlSME');
          String urlSRG = snapshotURL.get('urlSRG');
          String urlSRO = snapshotURL.get('urlSRO');
          String urlVPC = snapshotURL.get('urlVPC');
          String urlVSU = snapshotURL.get('urlVSU');
          String urlXNE = snapshotURL.get('urlXNE');

          urls = [
            urlK79 ?? '',
            urlSME ?? '',
            urlSRG ?? '',
            urlSRO ?? '',
            urlVPC ?? '',
            urlVSU ?? '',
            urlXNE ?? '',
          ];

          urls.forEach((url) {
            _canAccessURLs[url] = false;
          });
        });
      }
    } catch (e) {
      print('Error fetching URLs from Firestore: $e');
    }
  }

  Future<void> checkURL(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      setState(() {
        _canAccessURLs[url] = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        _canAccessURLs[url] = false;
      });
    }
  }

  void showPopup(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('URL check result'),
          content: Text(
            _canAccessURLs[url]!
                ? 'Can access the website.'
                : 'URL error, can\'t be accessed.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('URL Check')),
      body: Center(
        child: ListView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            final url = urls[index];
            final urlNames = [
              'Check Url K79exchange',
              'Check Url SiamExchange',
              'Check Url Superrichthailand',
              'Check Url Superrich1965',
              'Check Url Valueplusexchange',
              'Check Url Vasuexchange',
              'Check Url X-one',
            ];
            final urlName = urlNames[index];

            return Padding(
              padding: EdgeInsets.all(5.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () async {
                    await checkURL(url);
                    showPopup(context, url);
                  },
                  title: Text(
                    urlName,
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: ElevatedButton(
                    onPressed: () async {
                      await checkURL(url);
                      showPopup(context, url);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: CircleBorder(),
                    ),
                    child: Icon(Icons.link),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
