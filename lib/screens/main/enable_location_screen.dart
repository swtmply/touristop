import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touristop/main.dart';

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

    return TextButton(
      // Keep onPressed function
      onPressed: () async {
        data.userPosition = await _determinePosition();

        if (data.userPosition != null) {
          Navigator.pushNamed(context, '/calendar');
        }
      },
      child: const Text('Enable Location'),
    );
  }
}
