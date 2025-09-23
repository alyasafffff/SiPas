import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/dashboard/presentation/staff/screens/dashboard_staff_screen.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/laporan_saya_screen.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/semua_laporan_screen.dart';
import 'package:lapor_app/src/features/laporan/presentation/screens/tambah_laporan_screen.dart';
import 'package:lapor_app/src/features/profil/presentation/screens/profil_screen.dart';

// Halaman placeholder untuk tab yang belum kita buat
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Halaman $title"));
  }
}

class StaffNavigationScreen extends ConsumerStatefulWidget {
  const StaffNavigationScreen({super.key});

  @override
  ConsumerState<StaffNavigationScreen> createState() => _StaffNavigationScreenState();
}

class _StaffNavigationScreenState extends ConsumerState<StaffNavigationScreen> {
  int _selectedIndex = 0;

  // Daftar halaman/tab untuk Staff
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardStaffScreen(),
    LaporanSayaScreen(),
    SemuaLaporanScreen(), // Halaman yang sudah kita buat
    ProfilScreen()
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
        automaticallyImplyLeading: false, // Menghilangkan tombol back
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
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TambahLaporanScreen()),
          );
        },
        backgroundColor: const Color(0xFF0E2148),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E2148),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFF4B400),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Laporan Saya"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Semua Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),

    );
  }
}