import 'package:flutter/material.dart';
import 'package:lapor_app/halaman_notifikasi.dart';
import 'package:lapor_app/profil.dart';
import 'package:lapor_app/staff/dashboard.dart';
import 'package:lapor_app/staff/laporan_saya.dart';
import 'package:lapor_app/staff/semua_laporan.dart';

class NavigasiStaff extends StatefulWidget {
  const NavigasiStaff({super.key});

  @override
  State<NavigasiStaff> createState() => _DashboardStaffPageState();
}

class _DashboardStaffPageState extends State<NavigasiStaff> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _tabs = [DashboardTab(), LaporanSayaTab(), SemuaLaporanTab(), ProfilPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E2148),
        title: const Text(
          "SiPas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.white, height: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotifikasiPage()),
              );
            },
          ),
        ],
      ),

      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: const Color(0xFF0E2148),
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  selectedItemColor: const Color(0xFFF4B400), // pakai ini
  unselectedItemColor: Colors.white,
  type: BottomNavigationBarType.fixed,        // tambahin ini
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: "Dashboard",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Laporan Saya",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: "Semua Laporan",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_rounded),
      label: "Profil",
    ),
  ],
),

    );
  }
}
