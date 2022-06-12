import 'package:hive/hive.dart';
import 'package:touristop/models/app_geopoint/app_geopoint_model.dart';

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
  late String address;
  @HiveField(4)
  late String fee;
  @HiveField(5)
  late AppGeoPoint? position;
  @HiveField(6)
  late String type;
  @HiveField(7)
  late List<dynamic> dates;
  @HiveField(8)
  late double? averageRating;
  @HiveField(9)
  late double? distanceFromUser;
  @HiveField(10)
  late double numberOfHours;
  @HiveField(11)
  late String guideline;

  TouristSpot({
    required this.name,
    required this.description,
    required this.image,
    required this.address,
    required this.fee,
    this.position,
    required this.type,
    required this.dates,
    this.averageRating,
    this.distanceFromUser,
    required this.numberOfHours,
    required this.guideline,
  });
}
