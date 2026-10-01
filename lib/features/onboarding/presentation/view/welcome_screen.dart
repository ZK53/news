import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/constants/image_assets.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/core/widgets/custon_bottom.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_cubit.dart';
import 'package:news/features/onboarding/presentation/view/mapscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Sky gradient behind the buildings.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF16214F),
                  Color(0xFF2C48D9),
                  Color(0xFF5C7BEF),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 400,
            child: Image.asset(
              AppImages.welcomeBuildings,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 430,
              height: 421,
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Get The Latest News\nAnd Updates',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'From Politics to Entertainment: Your One- \nStop  Source for Comprehensive Coverage\n of the Latest News and Developments\n Across the Glob will be right on your hand.'
                    '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  CustomButton(
                    text: 'Explore',
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => MapCubit()..initializeLocation(),
                            child: const Mapscreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
