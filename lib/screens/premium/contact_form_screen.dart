import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common_widgets.dart';
import '../../services/center_service.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});
  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _centerNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _learnersController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _centerNameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _learnersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) return _buildSuccess();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Liên hệ B2B'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/premium'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomCard(
                color: AppColors.primaryLight,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.business, color: AppColors.primary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Đăng ký gói B2B cho trung tâm của bạn. Đội ngũ sẽ liên hệ trong 24h.',
                        style: TextStyle(color: AppColors.primaryDark, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _label('Tên trung tâm'),
              TextFormField(
                controller: _centerNameController,
                validator: (v) => v!.isEmpty ? 'Vui lòng nhập tên trung tâm' : null,
                decoration: const InputDecoration(hintText: 'VD: Trung tâm ABC', prefixIcon: Icon(Icons.business)),
              ),
              const SizedBox(height: 16),

              _label('Người liên hệ'),
              TextFormField(
                controller: _contactPersonController,
                validator: (v) => v!.isEmpty ? 'Vui lòng nhập tên' : null,
                decoration: const InputDecoration(hintText: 'Họ và tên', prefixIcon: Icon(Icons.person_outlined)),
              ),
              const SizedBox(height: 16),

              _label('Số điện thoại'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Vui lòng nhập SĐT' : null,
                decoration: const InputDecoration(hintText: '0xxx xxx xxx', prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const SizedBox(height: 16),

              _label('Email'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Vui lòng nhập email';
                  if (!v.contains('@')) return 'Email không hợp lệ';
                  return null;
                },
                decoration: const InputDecoration(hintText: 'email@company.com', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 16),

              _label('Số lượng học viên'),
              TextFormField(
                controller: _learnersController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Vui lòng nhập số lượng';
                  final n = int.tryParse(v);
                  if (n == null || n < 20) return 'Tối thiểu 20 học viên';
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Tối thiểu 20', prefixIcon: Icon(Icons.groups_outlined)),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Gửi yêu cầu',
                icon: Icons.send_rounded,
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
      ),
    );
  }

  final _centerService = CenterService();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    
    try {
      await _centerService.submitB2BContact({
        'centerName': _centerNameController.text.trim(),
        'contactPerson': _contactPersonController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'numberOfLearners': int.parse(_learnersController.text.trim()),
      });
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSubmitted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại sau!')),
        );
      }
    }
  }

  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
              ),
              const SizedBox(height: 24),
              const Text(
                'Đã gửi thành công! ✅',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Đội ngũ SignMate sẽ liên hệ với bạn trong vòng 24 giờ.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: 'Về trang chủ',
                icon: Icons.home_rounded,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
