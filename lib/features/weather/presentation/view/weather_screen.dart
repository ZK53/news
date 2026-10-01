import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news/core/constants/image_assets.dart';
import 'package:news/core/helper/date_time_helper.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_cubit.dart';
import 'package:news/features/onboarding/presentation/view/mapscreen.dart';
import 'package:news/features/weather/presentation/cubit/weather_cubit/weather_cubit.dart';
import 'package:news/features/weather/presentation/cubit/weather_cubit/weather_state.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit()..getWeather(),
      child: const _WeatherView(),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView();

  Widget _statCard(String label, String value, String paths) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            SvgPicture.asset(paths),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
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
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: ((context, state) {
        if (state is WeatherLoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is WeatherErrorState) {
          return Scaffold(body: Center(child: Text(state.errorMsg)));
        }

        if (state is WeatherSuccessState) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.w, 16.h, 0.w, 20.h),
                    child: Container(
                      width: double.infinity,
                      height: 110.h,
                      color: AppColors.headerBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                '${DateTimeHelper.getGreeting()},',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                              ),
                              Text(
                                state.username,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.grey,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '    ${DateTimeHelper.getFormattedDate()}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.asset(AppIcons.sun),
                              SizedBox(width: 4.w),
                              Text(
                                '${state.weather.mainDescription} ${state.weather.temperature.round()}°C       ',
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 80.h),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.weather.cityName} - ${state.weather.country}",
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${state.weather.temperature.round().toString()}°",
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.asset(AppImages.sun2),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            state.weather.description,
                            style: TextStyle(
                              fontSize: 23.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Feels like ${state.weather.feelsLike.round()}°',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              _statCard(
                                'Fahrenheit',
                                '${(state.weather.temperature * 1.8).round() + 32}°',
                                AppIcons.thermometer,
                              ),
                              SizedBox(width: 12.w),
                              _statCard(
                                'Wind Speed',
                                '${state.weather.windSpeed} km/h',
                                AppIcons.wind,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              _statCard('UV Index', '0.2', AppIcons.sunny),
                              SizedBox(width: 12.w),
                              _statCard(
                                'Humidity',
                                '${state.weather.humidity}%',
                                AppIcons.rain,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) =>
                                          MapCubit(isChangingLocation: true)
                                            ..initializeLocation(),
                                      child: Mapscreen(
                                        isChangingLocation: true,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2D5BD0),
                                padding: EdgeInsets.all(14.r),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                              ),
                              label: Text(
                                'Change Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20.r,
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
          );
        }

        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }),
    );
  }
}
