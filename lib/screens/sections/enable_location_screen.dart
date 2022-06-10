// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/select_dates/select_dates_screen.dart';

class EnableLocationScreen extends ConsumerWidget {
  const EnableLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "assets/images/pin_location_banner.png",
              width: size.width,
              height: size.height * 0.7,
              scale: 0.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 50,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 85,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: const Color.fromRGBO(93, 107, 230, 1),
                primary: Colors.white,
              ),
              onPressed: () async {
                await userLocation.locateUser();

                if (userLocation.position != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SelectDatesScreen(),
                    ),
                  );
                }
              },
              child: const Text(
                'Enable Location',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
