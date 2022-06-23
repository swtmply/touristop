import 'package:hive/hive.dart';

part 'destination_position.g.dart';

@HiveType(typeId: 1)
class DestinationPosition extends HiveObject {
  @HiveField(0)
  final double latitude;
  @HiveField(1)
  final double longitude;

  DestinationPosition({
    required this.latitude,
    required this.longitude,
  });
}
