// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/plan.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_bundle.dart';
import 'package:touristop/providers/spots_provider.dart';
import 'package:touristop/screens/sections/enable_location_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/authentication.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_banner.png",
              width: size.width,
              height: size.height * 0.7,
              scale: 0.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 40),
            const GoogleSignInButton(),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () async {
                User? user = await Authentication.signInAnonymously();

                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const EnableLocationScreen(),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 38,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: AppColors.coldBlue,
                primary: Colors.white,
              ),
              icon: const Icon(
                FontAwesomeIcons.user,
                size: 32,
              ),
              label: const Text(
                'Sign in as Guest',
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

class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  bool _isSigningin = true;

  @override
  Widget build(BuildContext context) {
    final datesBox = Hive.box<DatesList>('dates');
    final spotsBox = Hive.box<SpotsList>('spots');
    final plan = Hive.box<Plan>('plan');

    final dates = ref.watch(datesProvider);
    final selectedBundles = ref.watch(selectedBundleProvider);
    final allSpots = ref.watch(spotsProvider);

    return _isSigningin
        ? TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              backgroundColor: const Color.fromRGBO(93, 230, 197, 1),
              primary: Colors.white,
            ),
            onPressed: () async {
              setState(() {
                _isSigningin = false;
              });

              dates.datesList.clear();
              selectedBundles.selectedSpots.clear();
              allSpots.spots.clear();

              await spotsBox.clear();
              await datesBox.clear();
              await plan.clear();

              User? user =
                  await Authentication.signInWithGoogle(context: context);

              setState(() {
                _isSigningin = true;
              });

              if (user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const EnableLocationScreen(),
                  ),
                );
              }
            },
            icon: const Icon(
              FontAwesomeIcons.google,
              size: 32,
            ),
            label: const Text(
              'Sign in with Google',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : const CircularProgressIndicator.adaptive();
  }
}
