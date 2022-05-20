
import 'package:hive/hive.dart';
import 'package:touristop/models/geopoint.dart';

part 'tourist_spot_model.g.dart';

@HiveType(typeId: 1)
class TouristSpot extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String image;
  @HiveField(3)
  List<dynamic>? dates;
  @HiveField(4)
  late GeoPoint position;
  @HiveField(5)
  late double distanceFromUser;

  TouristSpot(
      {required this.name,
      required this.description,
      required this.image,
      this.dates,
      required this.position,
      required this.distanceFromUser});
}
