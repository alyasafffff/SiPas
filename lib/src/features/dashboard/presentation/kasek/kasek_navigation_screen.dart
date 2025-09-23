import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/dashboard/presentation/kasek/screens/dashboard_kasek_screen.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/semua_laporan_screen.dart';

// Menggunakan ulang placeholder screen dari file staff
import 'package:lapor_app/src/features/dashboard/presentation/staff/staff_navigation_screen.dart';
import 'package:lapor_app/src/features/profil/presentation/screens/profil_screen.dart';
import 'package:lapor_app/src/features/user_management/presentation/screens/manajemen_user_screen.dart';


class KasekNavigationScreen extends ConsumerStatefulWidget {
  const KasekNavigationScreen({super.key});

  @override
  ConsumerState<KasekNavigationScreen> createState() => _KasekNavigationScreenState();
}

class _KasekNavigationScreenState extends ConsumerState<KasekNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardKasekScreen(),
    SemuaLaporanScreen(), // Halaman yang sudah kita buat
    ManajemenUserScreen(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SiPas"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigasi ke halaman notifikasi
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E2148),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFF4B400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Semua Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Staff"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}