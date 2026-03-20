import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary), onPressed: () => context.go('/login'))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 20),
            const Text('Tạo tài khoản', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Bắt đầu hành trình học ngôn ngữ ký hiệu', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            _field(_nameController, 'Họ và tên', Icons.person_outlined),
            const SizedBox(height: 16),
            _field(_emailController, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _field(_passwordController, 'Mật khẩu', Icons.lock_outlined, obscure: true),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () => context.go('/register-step2'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              )),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Đã có tài khoản? ', style: TextStyle(color: AppColors.textSecondary)),
              GestureDetector(onTap: () => context.go('/login'),
                child: const Text('Đăng nhập', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon, {bool obscure = false, TextInputType? type}) {
    return TextField(controller: c, obscureText: obscure, keyboardType: type,
      decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textLight),
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2))));
  }
}
