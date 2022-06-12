import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/map/widgets/destination_card.dart';
import 'package:touristop/screens/main/map/widgets/destination_information.dart';
import 'package:touristop/screens/main/map/widgets/distance_card.dart';
import 'package:touristop/theme/app_colors.dart';

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

  late BitmapDescriptor userMarker, spotMarker;

  Future _initCustomMarkers() async {
    userMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(16, 16)),
        'assets/images/user-marker.png');
    spotMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(16, 16)),
        'assets/images/spot-marker.png');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initCustomMarkers();
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);
    final spot = widget.spot;

    LatLng destinationPosition = LatLng(
      spot.position!.latitude,
      spot.position!.longitude,
    );

    return Scaffold(
      body: StreamBuilder<Position>(
          stream: userLocation.getLiveLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 170,
                  height: 170,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    colors: [AppColors.coldBlue, AppColors.slime],
                  ),
                ),
              );
            }

            final position = snapshot.data;

            LatLng userPosition = LatLng(
              position?.latitude ?? 14.5995,
              position?.longitude ?? 120.9842,
            );

            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: userPosition,
                    zoom: 14.476,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);

                    _createPolylines(userPosition, destinationPosition);

                    makeMarker(destinationPosition, spotMarker);
                    makeMarker(userPosition, userMarker);
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
            );
          }),
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
          color: AppColors.coldBlue,
          points: polylineCoordinates,
          width: 3,
        );

        // Adding the polyline to the map
        polylines[id] = polyline;
      });
    }
  }

  makeMarker(LatLng position, BitmapDescriptor customMarker) {
    Marker marker = Marker(
      markerId: MarkerId(_markers.length.toString()),
      position: position,
      icon: customMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }
}
