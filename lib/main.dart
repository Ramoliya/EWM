import 'package:ewm/screenui/dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

// this is a main widget of app and here we can set the name of application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EWM',
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}