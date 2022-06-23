import 'package:hive_flutter/adapters.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/destination/destination_schedule.dart';
import 'package:touristop/models/destination/destination_position.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';

class Boxes {
  static String destinations = 'destinations';
  static String selectedDestinations = 'selected-destinations';
  static String schedule = 'schedule';

  static void initializeAdapters() {
    Hive.registerAdapter(DestinationAdapter());
    Hive.registerAdapter(DestinationPositionAdapter());
    Hive.registerAdapter(DestinationScheduleAdapter());
    Hive.registerAdapter(SelectedDestinationAdapter());
    Hive.registerAdapter(ScheduleAdapter());
  }
}
