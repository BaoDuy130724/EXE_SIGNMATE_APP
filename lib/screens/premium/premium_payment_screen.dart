import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../utils/app_colors.dart';

class PremiumPaymentScreen extends StatefulWidget {
  const PremiumPaymentScreen({super.key});
  @override
  State<PremiumPaymentScreen> createState() => _PremiumPaymentScreenState();
}

class _PremiumPaymentScreenState extends State<PremiumPaymentScreen> {
  WebViewController? _controller;
  String? _paymentUrl;
  bool _isLoading = true;
  bool _paymentComplete = false;
  bool _paymentSuccess = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map<String, dynamic> && _paymentUrl == null) {
      _paymentUrl = extra['paymentUrl'] as String?;
      if (_paymentUrl != null) {
        _initWebView();
      }
    }
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            // Detect VNPay return URL
            if (url.contains('vnpay-return')) {
              _handlePaymentReturn(url);
            }
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_paymentUrl!));
  }

  void _handlePaymentReturn(String url) {
    final uri = Uri.parse(url);
    final responseCode = uri.queryParameters['vnp_ResponseCode'];

    setState(() {
      _paymentComplete = true;
      _paymentSuccess = responseCode == '00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Thanh toán VNPay'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/premium'),
        ),
      ),
      body: _paymentComplete
          ? _buildResultView()
          : _paymentUrl == null
              ? _buildErrorView()
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller!),
                    if (_isLoading)
                      const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            SizedBox(height: 16),
                            Text('Đang tải trang thanh toán...',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }

  Widget _buildResultView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _paymentSuccess ? Icons.check_circle : Icons.cancel,
              color: _paymentSuccess ? AppColors.success : AppColors.error,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              _paymentSuccess ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _paymentSuccess ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _paymentSuccess
                  ? 'Gói Premium đã được kích hoạt. Bạn có thể sử dụng tất cả tính năng ngay bây giờ!'
                  : 'Thanh toán không thành công. Vui lòng thử lại hoặc chọn phương thức khác.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go(_paymentSuccess ? '/home' : '/premium'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _paymentSuccess ? AppColors.success : AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _paymentSuccess ? 'Về trang chủ' : 'Thử lại',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.warning, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Không có thông tin thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng quay lại và chọn gói cần nâng cấp.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/premium'),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}