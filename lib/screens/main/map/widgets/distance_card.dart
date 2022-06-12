import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/distance.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:http/http.dart' as http;
import 'package:touristop/providers/user_location.dart';

class DistanceCard extends ConsumerWidget {
  const DistanceCard({Key? key, this.selectedSpot}) : super(key: key);

  final TouristSpot? selectedSpot;

  Future<Distance> fetchDistance(
      Position userPosition, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${userPosition.latitude},${userPosition.longitude}&destinations=${destination.latitude},${destination.longitude}&key=AIzaSyAjMSWhlbBDUTmEjl3sdBLFdTA6x0LbCCs';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return Distance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Distance');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);

    return Positioned(
      bottom: 220,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child: FutureBuilder(
            future: fetchDistance(
              userLocation.position!,
              LatLng(selectedSpot!.position!.latitude,
                  selectedSpot!.position!.longitude),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Distance:',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                      '${selectedSpot?.distanceFromUser?.toStringAsFixed(2)}km',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      )),
                  Text('Time Remaining:',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    (snapshot.data as Distance).time,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
