import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/core/constants/image_assets.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/features/onboarding/presentation/view/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SvgPicture.asset(AppImages.logo)
      ),
    );
  }
}
