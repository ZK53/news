import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/features/onboarding/presentation/cubit/splash_cubit/splash_cubit.dart';
import 'package:news/features/onboarding/presentation/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  runApp(ScreenUtilInit(designSize: Size(430, 932), child: KhabarApp()));
}

class KhabarApp extends StatelessWidget {
  const KhabarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khabar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Schibsted Grotesk',
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),
      home: BlocProvider(
        create: (_) => SplashCubit()..checkOnboarding(),
        child: SplashScreen(),
      ),
    );
  }
}
