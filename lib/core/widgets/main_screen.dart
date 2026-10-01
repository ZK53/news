import 'package:flutter/material.dart';
import 'package:news/core/widgets/app_bottom_nav.dart';
import 'package:news/features/book_mark/presentation/view/bookmark_screen.dart';
import 'package:news/features/explore/presentation/view/explore_screen.dart';
import 'package:news/features/home/presentation/view/home_screen.dart';
import 'package:news/features/weather/presentation/view/weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ExploreScreen(),
    BookmarkScreen(),
    WeatherScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
