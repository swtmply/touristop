import 'package:hive/hive.dart';

part 'dates_list_model.g.dart';

@HiveType(typeId: 3)
class DatesList extends HiveObject {
  @HiveField(0)
  late DateTime dateTime;
  @HiveField(1)
  late double timeRemaining;

  DatesList({
    required this.dateTime,
    required this.timeRemaining,
  });
}
