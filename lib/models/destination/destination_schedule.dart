import 'package:hive/hive.dart';

part 'destination_schedule.g.dart';

@HiveType(typeId: 2)
class DestinationSchedule extends HiveObject {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String timeOpen;
  @HiveField(2)
  final String timeClose;

  DestinationSchedule({
    required this.date,
    required this.timeOpen,
    required this.timeClose,
  });
}
