import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/destination/destination_model.dart';

part 'schedule_model.g.dart';

@HiveType(typeId: 3)
class Schedule extends HiveObject {
  @HiveField(0)
  late DateTime date;
  @HiveField(2)
  late DateTime? startHour;
  @HiveField(3)
  late DateTime? endHour;
  @HiveField(4)
  late String? scheduleName;

  Schedule({
    required this.date,
    this.startHour,
    this.endHour,
    this.scheduleName,
  });
}
