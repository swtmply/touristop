import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/map/widgets/floating_destination_cards.dart';
import 'package:touristop/screens/map/widgets/selected_destination_card.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/boxes.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final selectedDestinationsBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);

  late BitmapDescriptor userMarker, spotMarker;
  Position? currentPosition;

  final Set<Marker> _markers = {};

  late List<SelectedDestination> _destinations;

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  Destination? _selectedDestination;

  void _onDestinationSelect(Destination? destination) {
    setState(() {
      _selectedDestination = destination;
    });
  }

  late Location location;
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();

    _destinations = selectedDestinationsBox.values.where((selectedDestination) {
      return selectedDestination.dateSelected ==
              DateUtils.dateOnly(DateTime.now())
          ? true
          : false;
    }).toList();

    _initCustomMarkers();
    location = Location();

    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      if (mounted) {
        setState(() {
          currentLocation = cLoc;
        });
      }
      updatePinOnMap();
    });
    setInitialLocation();
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: 14.0,
      bearing: 15.0,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        cPosition)); // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'user');
      _markers.add(Marker(
        markerId: MarkerId('user'),
        position: pinPosition, // updated position
        icon: userMarker,
      ));
    });
  }

  void setInitialLocation() async {
    final initialLocation = await location.getLocation();
    setState(() {
      currentLocation = initialLocation;
    });
    makeMarker(LatLng(initialLocation.latitude!, initialLocation.longitude!),
        userMarker, 'user');
  }

  Future _initCustomMarkers() async {
    userMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(16, 16)),
        'assets/icons/user-marker.png');
    spotMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(16, 16)),
        'assets/icons/spot-marker.png');
  }

  String _mode = 'driving';
  TravelMode _travelMode = TravelMode.driving;

  void _setMode(String mode) {
    setState(() {
      _mode = mode;
      if (_mode == 'walking') {
        _travelMode = TravelMode.walking;
      } else if (_mode == 'transit') {
        _travelMode = TravelMode.transit;
      } else {
        _travelMode = TravelMode.driving;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Container();
    }

    final LatLng position =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 14.476,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);

              if (_selectedDestination != null) {
                _onDestinationSelect(_selectedDestination);

                _createPolylines(
                  position,
                  LatLng(
                    _selectedDestination!.position.latitude,
                    _selectedDestination!.position.longitude,
                  ),
                );
              }

              // // initialize markers
              for (var selected in _destinations) {
                final position = LatLng(
                  selected.destination.position.latitude,
                  selected.destination.position.longitude,
                );
                makeMarker(position, spotMarker, selected.destination.name);
              }
            },
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Visibility(
            visible: _selectedDestination != null,
            child: SelectedDestinationCard(
              userPosition: position,
              destination: _selectedDestination,
              mode: _mode,
              setMode: _setMode,
              onModeChange: (mode) {
                setState(() {
                  _removePolylines();
                  _setMode(mode);
                  _createPolylines(
                    position,
                    LatLng(
                      _selectedDestination!.position.latitude,
                      _selectedDestination!.position.longitude,
                    ),
                  );
                });
              },
              onClose: () {
                setState(() {
                  _selectedDestination = null;
                  _removePolylines();
                });
              },
            ),
          ),
          Visibility(
            visible: _selectedDestination == null,
            child: FloatingDestinationCards(
              createPolyline: _createPolylines,
              destinations: _destinations.map((e) => e.destination).toList(),
              moveCamera: moveCamera,
              onDestinationSelect: _onDestinationSelect,
              userPosition: position,
            ),
          ),
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
      travelMode: _travelMode,
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

  makeMarker(LatLng position, BitmapDescriptor customMarker, String markerId) {
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: customMarker,
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
