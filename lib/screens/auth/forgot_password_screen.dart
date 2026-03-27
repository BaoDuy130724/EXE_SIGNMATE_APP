import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _nextStep() {
    FocusScope.of(context).unfocus();
    if (_currentStep < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu đã được đặt lại thành công!'), backgroundColor: AppColors.success),
      );
      context.go('/login');
    }
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            if (_currentStep > 0) {
                              _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                              setState(() => _currentStep--);
                            } else {
                              context.go('/login');
                            }
                          },
                        ),
                        const Expanded(
                          child: Text('Quên mật khẩu', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / 3,
                          minHeight: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Steps ──
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildEmailStep(), _buildOtpStep(), _buildNewPasswordStep()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String subtitle, Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_reset_rounded, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 28),
          child,
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 0 && !_emailController.text.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập email hợp lệ')));
                  return;
                }
                if (_currentStep == 1 && _otpController.text.length < 4) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập mã xác nhận')));
                  return;
                }
                if (_currentStep == 2) {
                  if (_passwordController.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu quá ngắn')));
                    return;
                  }
                  if (_passwordController.text != _confirmController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
                    return;
                  }
                }
                _nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                elevation: 0,
              ),
              child: Text(_currentStep == 2 ? 'Lưu mật khẩu mới' : 'Tiếp tục', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep() => _buildStep(
    'Quên mật khẩu?',
    'Nhập email liên kết với tài khoản để nhận mã xác nhận.',
    _inputField(_emailController, 'Email của bạn', TextInputType.emailAddress),
  );

  Widget _buildOtpStep() => _buildStep(
    'Nhập mã xác nhận',
    'Mã 6 số đã được gửi đến ${_emailController.text}',
    Column(
      children: [
        _inputField(_otpController, '000000', TextInputType.number, maxLength: 6, center: true),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Chưa nhận được? ', style: TextStyle(color: AppColors.textSecondary)),
          GestureDetector(onTap: () {}, child: const Text('Gửi lại', style: TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.bold))),
        ]),
      ],
    ),
  );

  Widget _buildNewPasswordStep() => _buildStep(
    'Mật khẩu mới',
    'Mật khẩu mới phải khác mật khẩu cũ.',
    Column(children: [
      _passwordField(_passwordController, 'Mật khẩu mới', _obscure1, (v) => setState(() => _obscure1 = v)),
      const SizedBox(height: 16),
      _passwordField(_confirmController, 'Xác nhận mật khẩu', _obscure2, (v) => setState(() => _obscure2 = v)),
    ]),
  );

  Widget _inputField(TextEditingController c, String hint, TextInputType type, {int? maxLength, bool center = false}) {
    return TextFormField(
      controller: c,
      keyboardType: type,
      maxLength: maxLength,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: center ? const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold) : null,
      decoration: InputDecoration(
        hintText: hint,
        counterText: '',
        hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }

  Widget _passwordField(TextEditingController c, String hint, bool obscure, ValueChanged<bool> toggle) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
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
