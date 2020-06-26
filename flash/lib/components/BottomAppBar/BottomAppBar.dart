import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippoapp/Screens/Post/NewPost.dart';
import 'package:flippoapp/Screens/Profile/ProfilePage.dart';
import 'package:flippoapp/components/BottomAppBar/fab_bottom_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Screens/Home/HomePage.dart';
FirebaseUser loggedInUser;
class BottomAppB extends StatefulWidget {
  @override
  _BottomAppBState createState() => _BottomAppBState();
}

class _BottomAppBState extends State<BottomAppB> with TickerProviderStateMixin {


  int _lastSelected =  0;
  final List<Widget> children = [
    HomePage(),
    ProfilePage(),
  ];
  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[_lastSelected],
      bottomNavigationBar: FABBottomAppBar(
        color: Colors.grey,
        selectedColor: Colors.red,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPost()));
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }
}
