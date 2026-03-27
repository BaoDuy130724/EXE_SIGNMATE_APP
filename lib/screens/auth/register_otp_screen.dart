import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

class RegisterOtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const RegisterOtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.mark_email_read_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Xác thực Email',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Chúng tôi đã gửi mã xác nhận 6 số đến email\n${widget.email}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 36),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '000000',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Xác nhận và Đăng ký',
                isLoading: _isLoading,
                icon: Icons.check_circle_outline,
                onPressed: _handleVerifyAndRegister,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa nhận được mã? ', style: TextStyle(color: AppColors.textSecondary)),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await context.read<AuthProvider>().sendRegisterOtp(widget.email);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã gửi lại mã OTP')),
                        );
                      } catch (e) {
                         if (!context.mounted) return;
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Đã có lỗi xảy ra khi gửi lại OTP')),
                         );
                      }
                    },
                    child: const Text(
                      'Gửi lại',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleVerifyAndRegister() async {
    if (_otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ 6 số OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final success = await auth.register(
        widget.name,
        widget.email,
        widget.password,
        _otpController.text,
      );

      if (!mounted) return;

      if (success) {
        context.go('/register-step2');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP không chính xác hoặc đã hết hạn.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra khi xác thực OTP.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
