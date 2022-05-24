import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
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
  final spotsBox = Hive.box<SpotBox>('spots');

  final Set<Marker> _markers = {};

  late PageController _pageController;
  int prevPage = 0;

  // ignore: todo
  // TODO add polylines
  // ignore: todo
  // TODO add realtime location
  // ignore: todo
  // TODO fade in and out animation of widgets

  TouristSpot? selectedSpot;

  void _onSpotSelect(TouristSpot? spot) {
    setState(() {
      selectedSpot = spot;
    });
  }

  void _onScroll() {
    if (_pageController.page?.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      final spotsList = spotsBox.values.toList();
      LatLng position = LatLng(
        spotsList[_pageController.page?.toInt() as int].spot.position.latitude,
        spotsList[_pageController.page?.toInt() as int].spot.position.longitude,
      );
      moveCamera(position);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);

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

              // initialize markers
              for (var spot in spotsBox.values) {
                makeMarker(
                  LatLng(spot.spot.position.latitude,
                      spot.spot.position.longitude),
                );
              }
              makeMarker(userPosition);
            },
            zoomControlsEnabled: false,
            markers: _markers,
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
              spots: spotsBox.values.toList(),
            ),
          )
        ],
      ),
    );
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
