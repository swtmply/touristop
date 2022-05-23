import 'package:hive/hive.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

part 'spot_box_model.g.dart';

@HiveType(typeId: 3)
class SpotBox extends HiveObject {
  @HiveField(0)
  late TouristSpot spot;

  @HiveField(1)
  late DateTime selectedDate;

  @HiveField(2, defaultValue: false)
  late bool? isFinished;

  SpotBox({
    required this.spot,
    required this.selectedDate,
    this.isFinished,
  });
}
