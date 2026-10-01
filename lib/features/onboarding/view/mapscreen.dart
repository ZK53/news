import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news/core/widgets/custom_search_field.dart';
import 'package:news/core/widgets/custon_bottom.dart';
import 'package:news/features/home/view/home_screen.dart';

class Mapscreen extends StatelessWidget {
  Mapscreen({super.key});

  final LatLng _currentPosition = LatLng(30.5877893, 31.4798788);
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

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
            child: Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _controller = controller,
                    markers: _markers,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.h),
                    child: CustomButton(
                      text: 'Get Started',
                      width: 180,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
