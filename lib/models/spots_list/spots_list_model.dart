import 'package:hive/hive.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

part 'spots_list_model.g.dart';

@HiveType(typeId: 2)
class SpotsList extends HiveObject {
  @HiveField(0)
  late DateTime date;
  @HiveField(1)
  late TouristSpot spot;
  @HiveField(2, defaultValue: false)
  late bool? isDone;
  @HiveField(3, defaultValue: false)
  late bool? isSelected;

  SpotsList({
    required this.date,
    required this.spot,
    this.isDone,
    this.isSelected,
  });
}
