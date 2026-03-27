import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ──
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(
                      child: Text('Đổi mật khẩu', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // ── Form ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mật khẩu phải có ít nhất 6 ký tự.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    const Text('Mật khẩu hiện tại', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _passwordField(_oldController, 'Nhập mật khẩu hiện tại', _obscureOld, (v) => setState(() => _obscureOld = v),
                      validator: (v) => v!.isEmpty ? 'Vui lòng nhập mật khẩu cũ' : null),
                    const SizedBox(height: 20),
                    const Text('Mật khẩu mới', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _passwordField(_newController, 'Nhập mật khẩu mới', _obscureNew, (v) => setState(() => _obscureNew = v),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu mới';
                        if (v.length < 6) return 'Tối thiểu 6 ký tự';
                        return null;
                      }),
                    const SizedBox(height: 20),
                    const Text('Xác nhận mật khẩu', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _passwordField(_confirmController, 'Nhập lại mật khẩu mới', _obscureConfirm, (v) => setState(() => _obscureConfirm = v),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Vui lòng xác nhận';
                        if (v != _newController.text) return 'Mật khẩu không khớp';
                        return null;
                      }),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đổi mật khẩu thành công!'), backgroundColor: AppColors.success),
                            );
                            context.go('/profile');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          elevation: 0,
                        ),
                        child: const Text('Cập nhật mật khẩu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController c, String hint, bool obscure, ValueChanged<bool> toggle, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 1.5)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textLight),
          onPressed: () => toggle(!obscure),
        ),
      ),
    );
  }
}
