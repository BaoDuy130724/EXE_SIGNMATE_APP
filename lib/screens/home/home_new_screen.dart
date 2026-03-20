import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
class HomeNewScreen extends StatelessWidget {
  const HomeNewScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(backgroundColor: AppColors.background, body: Center(child: Text('Welcome New User')));
}