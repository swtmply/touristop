import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/firebase/firestore/spots_firestore.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final _spotsFirestore = SpotsFirestore();

  Set<Marker> _markers = {};
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  late PageController _pageController;

  int prevPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userLocationProvider);

    LatLng userPosition = LatLng(
      userData.userPosition?.latitude ?? 14.5995,
      userData.userPosition?.longitude ?? 120.9842,
    );

    return Scaffold(
      body: FutureBuilder(
        future: _spotsFirestore.spotList,
        builder: (context, AsyncSnapshot<List<TouristSpot>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong 😂'),
            );
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: userPosition,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                  _initMarkers(userPosition, snapshot.data!);

                  // _createPolylines(userPosition, const LatLng(14.5826, 120.9787))
                  // _animateToSpot(const LatLng(14.5826, 120.9787))
                },
                zoomControlsEnabled: false,
                polylines: Set<Polyline>.of(polylines.values),
                markers: _markers,
              ),
              Positioned(
                bottom: 20.0,
                child: SizedBox(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) =>
                        _spotsList(index, snapshot.data![index]),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _spotsList(int index, TouristSpot spot) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 130.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // _createPolylines(userPosition, destination);
          // _animateToSpot(position);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          height: 150.0,
          width: 300.0,
          color: Colors.white,
          child: Text(spot.name.toString()),
        ),
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
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    // Defining an ID
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
  }

  // Initialize marker for map
  Future<void> _initMarkers(
      LatLng userPosition, List<TouristSpot> spots) async {
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

  void _onScroll() {
    if (_pageController.page?.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(14.5826, 120.9787),
          zoom: 14.0,
          bearing: 45.0,
          tilt: 45.0,
        ),
      ),
    );
  }
}
