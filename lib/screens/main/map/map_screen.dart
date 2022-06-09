import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/map/widgets/destination_card.dart';
import 'package:touristop/screens/main/map/widgets/destination_information.dart';
import 'package:touristop/screens/main/map/widgets/distance_card.dart';
import 'package:touristop/screens/main/map/widgets/floating_cards.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final spotsBox = Hive.box<SpotsList>('spots');

  final Set<Marker> _markers = {};

  late PageController _pageController;
  int prevPage = -1;

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  TouristSpot? selectedSpot;
  late List<SpotsList> spots;

  void _onSpotSelect(TouristSpot? spot) {
    setState(() {
      selectedSpot = spot;
    });
  }

  void _onScroll() {
    if (_pageController.page?.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      final spotsList = spots;
      LatLng position = LatLng(
        spotsList[_pageController.page?.toInt() as int].spot.position!.latitude,
        spotsList[_pageController.page?.toInt() as int]
            .spot
            .position!
            .longitude,
      );
      moveCamera(position);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8)
      ..addListener(_onScroll);

    spots = spotsBox.values.where((spotBox) {
      return DateFormat('yMd').format(spotBox.date).toString() ==
              DateFormat('yMd').format(DateTime.now()).toString()
          ? true
          : false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);
    final selected = ref.watch(selectedSpotsProvider);

    LatLng userPosition = LatLng(
      userLocation.position?.latitude ?? 14.5995,
      userLocation.position?.longitude ?? 120.9842,
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

              if (selected.firstSpot != null) {
                _onSpotSelect(selected.firstSpot);
              }

              if (selected.firstSpot != null) {
                _createPolylines(
                  userPosition,
                  LatLng(
                    selected.firstSpot!.position!.latitude,
                    selected.firstSpot!.position!.longitude,
                  ),
                );
              }

              // initialize markers
              for (var spot in spots) {
                final position = LatLng(
                  spot.spot.position!.latitude,
                  spot.spot.position!.longitude,
                );
                makeMarker(position);
              }
              makeMarker(userPosition);
            },
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Visibility(
            visible: selectedSpot != null,
            child: DestinationCard(
              selectedSpot: selectedSpot,
            ),
          ),
          Visibility(
            visible: selectedSpot != null,
            child: DistanceCard(
              selectedSpot: selectedSpot,
            ),
          ),
          Visibility(
            visible: selectedSpot != null,
            child: DestinationInformation(
              onClose: () {
                setState(() {
                  selectedSpot = null;
                  _removePolylines();
                });
              },
              selectedSpot: selectedSpot,
            ),
          ),
          Visibility(
            visible: selectedSpot == null,
            child: FloatingCards(
              onSpotSelect: _onSpotSelect,
              pageController: _pageController,
              spots: spots,
              moveCamera: moveCamera,
              createPolyline: _createPolylines,
            ),
          )
        ],
      ),
    );
  }

  _removePolylines() {
    setState(() {
      polylines.clear();
      polylineCoordinates.clear();
    });
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
    inspect(result);

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

  moveCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 14.0,
          bearing: 45.0,
        ),
      ),
    );
  }
}
