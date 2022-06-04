import 'package:hive/hive.dart';

part 'app_geopoint_model.g.dart';

@HiveType(typeId: 0)
class AppGeoPoint extends HiveObject {
  @HiveField(0)
  late double latitude;
  @HiveField(1)
  late double longitude;

  AppGeoPoint({
    required this.longitude,
    required this.latitude,
  });
}
