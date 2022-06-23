// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/enable_location_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/authentication.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/images/login_banner.png",
            width: size.width,
            height: size.height * 0.7,
            scale: 0.5,
            fit: BoxFit.fill,
          ),
          const SizedBox(
            height: AppSpacing.xl,
          ),
          const SignInButton(
            label: 'Sign in with Google',
            icon: Icon(FontAwesomeIcons.google),
            backgroundColor: AppColors.slime,
            authType: AuthType.google,
          ),
          const SizedBox(
            height: AppSpacing.small,
          ),
          const SignInButton(
            label: 'Sign in as Guest',
            icon: Icon(FontAwesomeIcons.userLock),
            backgroundColor: AppColors.coldBlue,
            authType: AuthType.guest,
          ),
        ],
      ),
    );
  }
}

class SignInButton extends ConsumerStatefulWidget {
  final String label;
  final Widget icon;
  final Color? backgroundColor;
  final AuthType authType;
  const SignInButton({
    Key? key,
    required this.label,
    required this.icon,
    this.backgroundColor,
    required this.authType,
  }) : super(key: key);

  @override
  ConsumerState<SignInButton> createState() => _SignInButtonState();
}

const double BUTTON_HEIGHT = 50;

class _SignInButtonState extends ConsumerState<SignInButton> {
  bool _isSigningin = true;

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final icon = widget.icon;
    final backgroundColor = widget.backgroundColor;
    final authType = widget.authType;

    final userLocation = ref.watch(userLocationProvider);

    if (_isSigningin) {
      return Padding(
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
              backgroundColor: backgroundColor,
              primary: Colors.white,
              minimumSize: const Size.fromHeight(BUTTON_HEIGHT),
            ),
            onPressed: () async {
              setState(() {
                _isSigningin = false;
              });

              User? user;

              if (authType == AuthType.google) {
                user = await Authentication.signInWithGoogle(context: context);
              } else {
                user = await Authentication.signInAnonymously();
              }

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
            icon: icon,
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator.adaptive();
    }
  }
}

enum AuthType {
  google,
  guest,
}
