// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/date_selection/date_selection_screen.dart';
import 'package:touristop/screens/login_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class EnableLocationScreen extends ConsumerWidget {
  const EnableLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/images/pin_location_banner.png",
            width: size.width,
            height: size.height * 0.7,
            scale: 0.5,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: SizedBox(
              height: BUTTON_HEIGHT,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: AppColors.coldBlue,
                  primary: Colors.white,
                  minimumSize: const Size.fromHeight(BUTTON_HEIGHT),
                ),
                onPressed: () async {
                  await userLocation.locatePosition();

                  if (userLocation.position != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DateSelectionScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.locationDot,
                ),
                label: const Text(
                  'Enable Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
