import 'package:geolocator/geolocator.dart';
import 'package:touristop/models/app_geopoint/app_geopoint_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class ConvertTo {
  static TouristSpot touristSpot(
      Map<String, dynamic> document, Position userPosition) {
    final position = AppGeoPoint(
      latitude: document['position'].latitude,
      longitude: document['position'].longitude,
    );
    double distanceFromUser = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      userPosition.latitude,
      userPosition.longitude,
    );

    return TouristSpot(
      name: document['name'],
      description: document['description'],
      image: document['image'],
      position: position,
      address: document['address'],
      fee: document['fee'],
      distanceFromUser: distanceFromUser / 1000,
      dates: document['dates'],
      type: document['type'],
      numberOfHours: double.parse(document['numberOfHours'].toString()),
    );
  }
}
