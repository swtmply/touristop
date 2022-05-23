import 'package:hive/hive.dart';

part 'geopoint_model.g.dart';

@HiveType(typeId: 2)
class GeoPoint extends HiveObject {
  @HiveField(0)
  late double latitude;

  @HiveField(1)
  late double longitude;
}
