import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/core/constants/image_assets.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/core/widgets/main_screen.dart';
import 'package:news/features/onboarding/presentation/cubit/splash_cubit/splach_state.dart';
import 'package:news/features/onboarding/presentation/cubit/splash_cubit/splash_cubit.dart';
import 'package:news/features/onboarding/presentation/view/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: ((context, state) {
        if (state is SplashShowHomeState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }

        if (state is SplashShowWelcomeState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          );
        }
      }),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: SvgPicture.asset(AppImages.logo)),
      ),
    );
  }
}
