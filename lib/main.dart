import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(SmartphoneApp());
}

class SmartphoneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartphone Models',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
