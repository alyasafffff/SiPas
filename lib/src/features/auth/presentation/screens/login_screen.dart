import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lapor_app/src/features/auth/application/auth_controller.dart';

import 'package:lapor_app/src/features/dashboard/presentation/kasek/kasek_navigation_screen.dart';
import 'package:lapor_app/src/features/dashboard/presentation/staff/staff_navigation_screen.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong')),
      );
      return;
    }

    // Memanggil fungsi login dari AuthController
    final success = await ref
        .read(authControllerProvider.notifier)
        .login(_emailController.text, _passwordController.text);

    if (success && mounted) {
      final user = ref.read(authControllerProvider).value;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => user?.role == 'Admin'
            ? const KasekNavigationScreen()
            : const StaffNavigationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantau state dari AuthController
    final authState = ref.watch(authControllerProvider);

    // Tampilkan pesan error jika ada
    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0E2148),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/logo.png"), width: 80, height: 80),
              const SizedBox(height: 10),
              const Text("SiPas", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 20),
              _EmailTextField(controller: _emailController),
              const SizedBox(height: 16),
              _PasswordTextField(controller: _passwordController),
              const SizedBox(height: 24),

              // Ganti tombol dengan versi yang bisa menampilkan loading
              authState.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : _LoginButton(onPressed: _handleLogin),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET-WIDGET KECIL (TIDAK BERUBAH) ---
class _EmailTextField extends StatelessWidget {
  const _EmailTextField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.person, color: Colors.white70),
      ),
    );
  }
}
class _PasswordTextField extends ConsumerStatefulWidget {
  const _PasswordTextField({required this.controller});
  final TextEditingController controller;
  @override
  ConsumerState<_PasswordTextField> createState() => _PasswordTextFieldState();
}
class _PasswordTextFieldState extends ConsumerState<_PasswordTextField> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }
}
class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E90FF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}