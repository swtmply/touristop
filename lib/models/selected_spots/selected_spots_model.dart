import 'package:hive/hive.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

part 'selected_spots_model.g.dart';

@HiveType(typeId: 4)
class SelectedSpots extends HiveObject {
  @HiveField(0)
  TouristSpot spot;

  SelectedSpots({
    required this.spot,
  });
}
