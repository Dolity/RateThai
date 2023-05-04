import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testprojectbc/screen/display.dart';
import 'package:testprojectbc/screen/formscreen.dart';




class AddpostPage extends StatefulWidget {
  const AddpostPage({Key? key}) : super(key: key);

  State<AddpostPage> createState() => _AddpostPage();
}

class _AddpostPage extends State<AddpostPage> {

  
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              FormScreen(),
              DisplayScreen()
            ],
          ),
          backgroundColor: Colors.blue,
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(text: 'FireStore',),
              Tab(text: 'User',)
            ],
          ),

        )
    );
 
  }

}