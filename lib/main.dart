import 'package:concon/pages/home/home_page.dart';
//import 'package:homework5/pages/pin_login/pin_login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CONCON',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 6, 8, 45),
          //brightness: Brightness.dark,
        ),
        useMaterial3: true,
        backgroundColor: const Color.fromARGB(255, 4, 12, 19), 
      ),
      // home: const PinLoginPage(),
      home: const HomePage(),
    );
  }
}