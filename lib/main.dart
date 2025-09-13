import 'package:flutter/material.dart';
import 'splash_screen.dart'; // pastikan file splash_screen.dart ada
// jangan import login.dart di sini, karena login dipanggil dari splash

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lapor App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // mulai dari splash
    );
  }
}
