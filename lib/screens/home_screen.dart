import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/screens/pages/addVideo_page.dart';
import 'package:tiktok_clone/screens/pages/message_page.dart';
import 'package:tiktok_clone/screens/pages/profile_page.dart';
import 'package:tiktok_clone/screens/pages/search_page.dart';
import 'package:tiktok_clone/screens/pages/video_page.dart';
import 'package:tiktok_clone/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double CreateButtonWidth = 38.0;

  List pageOptions = [
    VideoPage(),
    SearchPage(),
    AddVideoPage(),
    MessagePage(),
    ProfilePage(FirebaseAuth.instance.currentUser.uid),
  ];

  int pageIdx = 0;

  customIcon() {
    return Container(
      width: 45.0,
      height: 30.0,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 45, 108),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: CreateButtonWidth,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: CreateButtonWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0)),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            title: Text(
              "Home",
              style: ralewayStyle(12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            title: Text(
              "Search",
              style: ralewayStyle(12),
            ),
          ),
          BottomNavigationBarItem(
            icon: customIcon(),
            title: Text(
              "",
              style: ralewayStyle(12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 30,
            ),
            title: Text(
              "Messages",
              style: ralewayStyle(12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            title: Text(
              "Profile",
              style: ralewayStyle(12),
            ),
          ),
        ],
      ),
      body: pageOptions[pageIdx],
    );
  }
}
