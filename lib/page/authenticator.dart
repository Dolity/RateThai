import 'package:flutter/material.dart';

class AuthenticatorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthenticatorPage();
  }
}

class _AuthenticatorPage extends State<AuthenticatorPage> {
  bool chk1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Text(
                "Security",
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

            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            //     child: Theme(
            //       data: ThemeData(
            //         checkboxTheme: CheckboxThemeData(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(25),
            //           ),
            //         ),
            //         unselectedWidgetColor: Color(0xFF7C8791),
            //       ),
            //       child: CheckboxListTile(
            //         value: chk1 ??= false,
            //         onChanged: (newValue) async {
            //           setState(() => chk1 = newValue!);
            //
            //         },
            //
            //         title: const Text(
            //           'Authenticator App',
            //           // style: Theme.of(context)
            //           //     .subtitle1
            //           //     .override(
            //           // fontFamily: 'Outfit',
            //           // color: Color(0xFF090F13),
            //           // fontSize: 20,
            //           // fontWeight: FontWeight.w500,
            //           // ),
            //         ),
            //         subtitle: const Text(
            //           'Highly secure',
            //           // style: FlutterFlowTheme.of(context)
            //           //     .bodyText2
            //           //     .override(
            //           // fontFamily: 'Outfit',
            //           // color: Color(0xFF7C8791),
            //           // fontSize: 14,
            //           // fontWeight: FontWeight.normal,
            //           // ),
            //         ),
            //         tileColor: Color(0xFFF5F5F5),
            //         activeColor: Color(0xFF4B39EF),
            //         checkColor: Color(0xFF090F13),
            //         dense: false,
            //         controlAffinity: ListTileControlAffinity.trailing,
            //       ),
            //     ),
            //   ),
            // ),




          ],
        ),
      ),
    );
  }
}
