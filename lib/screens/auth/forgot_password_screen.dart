import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';

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
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      // Done - show success and go to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu đã được đặt lại thành công!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/login');
    }
  }

  void _prevStep() {
    FocusScope.of(context).unfocus();
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
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
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  minHeight: 4,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildEmailStep(),
                  _buildOtpStep(),
                  _buildNewPasswordStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContainer(String title, String subtitle, Widget child) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_reset_rounded, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 36),
          child,
          const SizedBox(height: 32),
          CustomButton(
            text: _currentStep == 2 ? 'Lưu mật khẩu mới' : 'Tiếp tục',
            icon: _currentStep == 2 ? Icons.check_circle_outline : Icons.arrow_forward_rounded,
            onPressed: () {
              // Basic validation
              if (_currentStep == 0 && !_emailController.text.contains('@')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập email hợp lệ')),
                );
                return;
              }
              if (_currentStep == 1 && _otpController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập mã xác nhận')),
                );
                return;
              }
              if (_currentStep == 2) {
                if (_passwordController.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu quá ngắn')),
                  );
                  return;
                }
                if (_passwordController.text != _confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mật khẩu không khớp')),
                  );
                  return;
                }
              }
              _nextStep();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailStep() {
    return _buildStepContainer(
      'Quên mật khẩu?',
      'Đừng lo! Nhập email liên kết với tài khoản của bạn để nhận mã xác nhận.',
      TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Email của bạn',
          prefixIcon: Icon(Icons.email_outlined, color: AppColors.textLight),
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return _buildStepContainer(
      'Nhập mã xác nhận',
      'Chúng tôi đã gửi mã xác nhận 6 số đến email\n${_emailController.text}',
      Column(
        children: [
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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Chưa nhận được mã? ', style: TextStyle(color: AppColors.textSecondary)),
              GestureDetector(
                onTap: () {}, // Resend logic
                child: const Text(
                  'Gửi lại',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return _buildStepContainer(
      'Tạo mật khẩu mới',
      'Mật khẩu mới của bạn phải khác với mật khẩu sử dụng trước đó.',
      Column(
        children: [
          TextFormField(
            controller: _passwordController,
            obscureText: _obscure1,
            decoration: InputDecoration(
              hintText: 'Mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textLight,
                ),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmController,
            obscureText: _obscure2,
            decoration: InputDecoration(
              hintText: 'Xác nhận mật khẩu mới',
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textLight,
                ),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
