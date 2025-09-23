import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/core/models/user_model.dart';
import 'package:lapor_app/src/features/user_management/application/user_controller.dart';
import 'package:lapor_app/src/features/user_management/presentation/screens/tambah_user_screen.dart';
import 'package:lapor_app/src/features/user_management/presentation/screens/user_detail_screen.dart';

class ManajemenUserScreen extends ConsumerWidget {
  const ManajemenUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListState = ref.watch(userControllerProvider);

    return Scaffold(
      // AppBar sudah ada di navigasi utama
      body: userListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserListTile(user: user);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TambahUserScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    Color roleColor = user.role.toLowerCase() == 'admin' ? Colors.green : Colors.orange;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(user.fotoProfilUrl), // Placeholder
          ),
          title: Text(user.nama, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text("Email: ${user.email}\nTerdaftar: ${user.tanggalDibuat.toLocal().toString().split(' ')[0]}"),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: roleColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(user.role, style: const TextStyle(color: Colors.white)),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserDetailScreen(user: user),
              ),
            );
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}