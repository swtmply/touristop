import 'package:cloud_firestore/cloud_firestore.dart';

class TouristSpot {
  String? name;
  String? description;
  String? image;
  List<dynamic>? dates;
  GeoPoint? position;
  double? distanceFromUser;

  TouristSpot(
      {this.name,
      this.description,
      this.image,
      this.dates,
      this.position,
      this.distanceFromUser});
}
