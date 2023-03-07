import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac Game',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF00061a),
          shadowColor: const Color(0xFF001456),
          splashColor: const Color(0xFF4169e8),
          fontFamily: 'OpenSans',
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            headlineLarge: TextStyle(
              fontSize: 52,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontSize: 42,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 25,
            opacity: 1.0,
          )),
      home: const HomePage(),
    );
  }
}
