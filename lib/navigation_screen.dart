import "package:flutter/material.dart";
import 'package:tiktok_clone/screens/login_screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isLoggedIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn ? LoginScreen(): Text("not logged in"),
    );
  }
}