import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lapor_app/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (_, __, ___) =>  LoginPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0E2148), // samain sama login page
      body: Center(
        child: Hero(
          tag: "appLogo",
          child: Image(
            image: AssetImage("assets/logo.png"),
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}
