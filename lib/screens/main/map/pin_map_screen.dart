import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/map/widgets/destination_card.dart';
import 'package:touristop/screens/main/map/widgets/destination_information.dart';
import 'package:touristop/screens/main/map/widgets/distance_card.dart';

class PinMapScreen extends ConsumerStatefulWidget {
  final TouristSpot spot;

  const PinMapScreen({Key? key, required this.spot}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinMapScreenState();
}

class _PinMapScreenState extends ConsumerState<PinMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);
    final spot = widget.spot;

    LatLng userPosition = LatLng(
      userLocation.position?.latitude ?? 14.5995,
      userLocation.position?.longitude ?? 120.9842,
    );

    LatLng destinationPosition = LatLng(
      spot.position!.latitude,
      spot.position!.longitude,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userPosition,
              zoom: 14.476,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              _createPolylines(userPosition, destinationPosition);

              makeMarker(destinationPosition);
              makeMarker(userPosition);
            },
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          DestinationCard(
            selectedSpot: spot,
          ),
          DistanceCard(
            selectedSpot: spot,
          ),
          DestinationInformation(
            onClose: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            selectedSpot: spot,
          ),
        ],
      ),
    );
  }

  _createPolylines(LatLng userPosition, LatLng destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAjMSWhlbBDUTmEjl3sdBLFdTA6x0LbCCs', // Google Maps API Key
      PointLatLng(userPosition.latitude, userPosition.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      setState(() {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        PolylineId id = PolylineId(destination.toString());

        // Initializing Polyline
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: polylineCoordinates,
          width: 3,
        );

        // Adding the polyline to the map
        polylines[id] = polyline;
      });
    }
  }

  makeMarker(LatLng position) {
    Marker marker = Marker(
      markerId: MarkerId(_markers.length.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }
}
