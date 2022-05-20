import 'package:hive/hive.dart';

part 'geopoint.g.dart';

@HiveType(typeId: 2)
class GeoPoint {
  @HiveField(0)
  late double latitude;

  @HiveField(1)
  late double longitude;
}
