import 'package:hive/hive.dart';

part 'date_model.g.dart';

@HiveType(typeId: 0)
class Date extends HiveObject {
  @HiveField(0)
  late DateTime date;
}
