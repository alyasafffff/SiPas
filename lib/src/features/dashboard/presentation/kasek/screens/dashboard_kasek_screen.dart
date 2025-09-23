import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardKasekScreen extends ConsumerWidget {
  const DashboardKasekScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Data ini akan kita buat lebih kompleks nanti (misal: statistik, grafik)
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "Dashboard Kasek\n(Grafik dan statistik akan ditampilkan di sini)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}