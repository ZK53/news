import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/core/constants/image_assets.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/core/widgets/app_bottom_nav.dart';
import 'package:news/features/book_mark/view/bookmark_screen.dart';
import 'package:news/features/explore/view/explore_screen.dart';
import 'package:news/features/home/view/home_screen.dart';
import 'package:news/features/onboarding/view/mapscreen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _onNavTap(BuildContext context, int index) {
    if (index == 3) return;
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const ExploreScreen();
        break;
      default:
        screen = const BookmarkScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _statCard(String label, String value, String paths) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            SvgPicture.asset(paths),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
              child: Container(
                width: double.infinity,
                height: 110,
                color: AppColors.headerBg,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Good Morning,',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                        ),
                        Text(
                          'Ahmed Saber',
                          style: TextStyle(fontSize: 14, color: AppColors.grey),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '    Sun 9 April, 2023',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(AppIcons.sun),
                        const SizedBox(width: 4),
                        const Text(
                          'Sunny 32°C       ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
                decoration: const BoxDecoration(color: AppColors.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cairo - EG',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '27',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(AppImages.sun2),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Clear - Clear Sky',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Feels like 28',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _statCard('Fahrenheit', '72°', AppIcons.thermometer),
                        const SizedBox(width: 12),
                        _statCard('Pressure', '134 mp/h', AppIcons.wind),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _statCard('UV Index', '0.2', AppIcons.sunny),
                        const SizedBox(width: 12),
                        _statCard('Humidity', '48%', AppIcons.rain),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Mapscreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5BD0),
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        label: const Text(
                          'Change Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (i) => _onNavTap(context, i),
      ),
    );
  }
}
