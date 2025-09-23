import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lapor_app/src/features/auth/presentation/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk pindah halaman setelah 2 detik
    Timer(const Duration(seconds: 2), () {
      // Pindah ke LoginScreen dan hapus SplashScreen dari tumpukan navigasi
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan Anda sudah menambahkan logo.png ke folder assets
    // dan mendaftarkannya di pubspec.yaml
    return const Scaffold(
      backgroundColor: Color(0xFF0E2148),
      body: Center(
        child: Image(
          image: AssetImage("assets/logo.png"),
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}