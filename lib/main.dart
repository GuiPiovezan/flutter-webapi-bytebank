import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BytebankApp());
  findAll();
}

class BytebankApp extends StatelessWidget {
  const BytebankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Dashboard(),
      theme: ThemeData(
        primaryColor: Colors.green[900],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary),
      ),
    );
  }
}
