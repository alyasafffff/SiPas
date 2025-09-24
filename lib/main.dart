import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 1. Import package
import 'splash_screen.dart';

// 2. Ubah fungsi main menjadi async
Future<void> main() async {
  // 3. Pastikan Flutter diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  // 4. Muat file .env dan tunggu sampai selesai
  await dotenv.load(fileName: ".env");

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
      home: const SplashScreen(),
    );
  }
}