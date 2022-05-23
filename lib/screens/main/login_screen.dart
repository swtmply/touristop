// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touristop/firebase/utils/authentication.dart';
import 'package:touristop/screens/sections/enable_location_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.7,
            ),
            // Image.asset(
            //   "/assets/images/login_banner.png",
            //   width: size.width,
            //   height: size.height * 0.7,
            //   scale: 0.5,
            //   fit: BoxFit.fill,
            // ),
            const SizedBox(
              height: 50,
            ),
            const GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningin = true;
  @override
  Widget build(BuildContext context) {
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
