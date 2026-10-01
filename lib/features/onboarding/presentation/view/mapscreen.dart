import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/cache/cache_keys.dart';
import 'package:news/core/widgets/custom_search_field.dart';
import 'package:news/core/widgets/custon_bottom.dart';
import 'package:news/features/home/presentation/view/home_screen.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_cubit.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_state.dart';

class Mapscreen extends StatelessWidget {
  const Mapscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 46.h),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: SafeArea(
              child: Container(
                height: 55.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomSearchField(
                  hintText: "Ahmed Saber",
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<MapCubit, MapState>(
              builder: ((context, state) {
                if (state is MapLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MapLocationSelectedState) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: state.location,
                            zoom: 15,
                          ),
                          onTap: (location) {
                            context.read<MapCubit>().selectLocation(location);
                          },
                          markers: {
                            Marker(
                              markerId: MarkerId("selected-location"),
                              position: state.location,
                            ),
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50.h),
                          child: CustomButton(
                            text: 'Get Started',
                            width: 180,
                            onPressed: () async {
                              await context.read<MapCubit>().confirmLocation();
                              await CacheHelper.setValue(
                                key: CacheKeys.onboardingCompleted,
                                value: true,
                              );
                              
                              if (!context.mounted) return;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is MapErrorState) {
                  return Center(child: Text(state.errorMsg));
                }

                return Center(child: Text("Something Happened"));
              }),
            ),
          ),
        ],
      ),
    );
  }
}
