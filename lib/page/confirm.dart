import 'package:flutter/material.dart';

class ConfirmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConfirmPage();
  }

}

class _ConfirmPage extends State <ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                "Check your inbox for a verifiaction email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            const Divider(
              height: 25,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.grey,
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: Text(
                "An email has been sent to",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                // style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: Text(
                "jakkit@gmail.INPUT!!",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                // style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      // minimumSize: const Size.fromWidth(20),
                      fixedSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      // message = _usernameController.text;

                      // Navigator.pushNamed(context, "/photo-page", arguments: [
                      //   // _usernameController.text,
                      //   // _passwordController.text
                      // ]);
                    },
                    label: Text(
                      'PENDING CONFIRMATION',
                      style: TextStyle(fontSize: 20),
                    ),
                    icon: Icon(Icons.email),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                      // minimumSize: const Size.fromWidth(20),
                      fixedSize: const Size(30, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      // message = _usernameController.text;

                      Navigator.pushNamed(context, "/photo-page", arguments: [
                        // _usernameController.text,
                        // _passwordController.text
                      ]);
                    },
                    label: Text(
                      '',
                      style: TextStyle(fontSize: 0),
                    ),
                    icon: Icon(Icons.refresh),
                  ),
                ),
              ],
            ),





          ],
        ),
      ),
    );
  }

}