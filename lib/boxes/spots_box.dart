import 'package:hive/hive.dart';
import 'package:touristop/models/tourist_spot_model.dart';

part 'spots_box.g.dart';

@HiveType(typeId: 0)
class SpotBox extends HiveObject {
  @HiveField(0)
  late TouristSpot touristSpot;

  @HiveField(1)
  late DateTime dateSelected;

  @HiveField(2, defaultValue: false)
  late bool isDone;
}
