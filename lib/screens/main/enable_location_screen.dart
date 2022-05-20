import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touristop/main.dart';
import 'package:google_fonts/google_fonts.dart';

class EnableLocationScreen extends ConsumerStatefulWidget {
  const EnableLocationScreen({Key? key}) : super(key: key);

  @override
  EnableLocationScreenState createState() => EnableLocationScreenState();
}

class EnableLocationScreenState extends ConsumerState<EnableLocationScreen> {
  // Call this function on button click for persmission and user's position
  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(userLocationProvider);

    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/sec.png'),
          const SizedBox(
            height: 70,
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(75, 15, 75, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              backgroundColor: const Color.fromRGBO(93, 107, 230, 1),
            ),
            onPressed: () async {
              data.userPosition = await _determinePosition();

              if (data.userPosition != null) {
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/calendar');
              }
            },
            child: Text(
              'Enable Location',
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
