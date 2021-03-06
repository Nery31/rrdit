import 'package:flutter/material.dart';
import 'package:my_app/login_page.dart';
import 'package:my_app/pages/feed.dart';
import 'package:my_app/pages/searchpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
