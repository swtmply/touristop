import 'package:hive/hive.dart';

part 'plan.g.dart';

@HiveType(typeId: 5)
class Plan extends HiveObject {
  @HiveField(0)
  late String selected;

  Plan({
    required this.selected,
  });
}
