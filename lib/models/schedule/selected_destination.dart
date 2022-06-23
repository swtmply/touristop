import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/destination/destination_model.dart';

part 'selected_destination.g.dart';

@HiveType(typeId: 4)
class SelectedDestination extends HiveObject {
  @HiveField(0)
  late DateTime dateSelected;
  @HiveField(1)
  late Destination destination;
  @HiveField(2, defaultValue: false)
  late bool isDone;

  SelectedDestination({
    required this.dateSelected,
    required this.destination,
    required this.isDone,
  });
}
