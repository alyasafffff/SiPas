import 'package:flutter/material.dart';
import 'package:lapor_app/halaman_notifikasi.dart';
import 'package:lapor_app/kasek/dashboard.dart';
import 'package:lapor_app/kasek/manajemen_user.dart';
import 'package:lapor_app/kasek/semua_laporan.dart';
import 'package:lapor_app/profil.dart';

class NavigasiKasek extends StatefulWidget {
  const NavigasiKasek({super.key});

  @override
  State<NavigasiKasek> createState() => _NavigasiKasekState();
}

class _NavigasiKasekState extends State<NavigasiKasek> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // tabs dengan callback
    final List<Widget> _tabs = [
      DashboardTabKasek(
        onLihatSemua: () {
          setState(() {
            _selectedIndex = 1; // tab Semua Laporan
          });
        },
      ),
      SemuaLaporanTabKasek(),
      ManajemenUserPage(),
      ProfilPage(),
    ];

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
        selectedItemColor: const Color(0xFFF4B400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Semua Laporan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Staff"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
