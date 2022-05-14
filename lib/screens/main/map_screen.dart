import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/firebase/firestore/spots_firestore.dart';
import 'package:touristop/main.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final _spotsFirestore = SpotsFirestore();

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(userLocationProvider);

    LatLng userPosition = LatLng(
      data.userPosition?.latitude ?? 14.5995,
      data.userPosition?.longitude ?? 120.9842,
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: userPosition,
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);

          _initMarkers(userPosition);
        },
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _animateToSpot(const LatLng(14.5826, 120.9787)),
        label: const Text('To Rizal Park!'),
        icon: const Icon(Icons.park),
      ),
    );
  }

  // Initialize marker for map
  Future<void> _initMarkers(LatLng userPosition) async {
    final spots = await _spotsFirestore.spotList;

    Marker userMarker = Marker(
      markerId: const MarkerId('user marker'),
      position: userPosition,
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers = spots
          .map(
            (spot) => Marker(
              markerId: MarkerId(spot.name.toString()),
              position: const LatLng(14.5826, 120.9787),
              icon: BitmapDescriptor.defaultMarker,
            ),
          )
          .toSet();

      _markers.add(userMarker);
    });
  }

  // Animate Camera to spot
  Future<void> _animateToSpot(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_animatedPosition(position)));
  }

  // Returns the spot to animate to
  CameraPosition _animatedPosition(LatLng position) {
    return CameraPosition(
      bearing: 192.8334901395799,
      target: position,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );
  }
}
