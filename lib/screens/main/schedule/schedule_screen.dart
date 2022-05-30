import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final datesBox = Hive.box<Date>('dates');
  final spotsBox = Hive.box<SpotBox>('spots');
  DateTime? _selectedDate;
  List<SpotBox>? _spotsList;

  List<SpotBox> _generateSpots(DateTime? date) {
    final spots = spotsBox.values.where((spotBox) {
      return spotBox.selectedDate == _selectedDate ? true : false;
    }).toList();

    spots.sort((a, b) {
      final day = DateFormat('E').format(_selectedDate!).toString();
      final scheduleA =
              a.spot.dates!.firstWhere((element) => element['date'] == day),
          scheduleB =
              b.spot.dates!.firstWhere((element) => element['date'] == day);

      String timeA = (scheduleA['timeClose'] as String)
              .replaceAll(RegExp('[^0-9:]'), ''),
          timeB = (scheduleB['timeClose'] as String)
              .replaceAll(RegExp('[^0-9:]'), '');

      TimeOfDay todA = _toTimeOfDay(timeA), todB = _toTimeOfDay(timeB);

      return toDouble(todA) > toDouble(todB) ? 1 : 0;
    });

    return spots;
  }

  TimeOfDay _toTimeOfDay(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  double toDouble(TimeOfDay time) => time.hour + time.minute / 60.0;

  @override
  void initState() {
    super.initState();
    _selectedDate = datesBox.values.first.date;
    _spotsList = _generateSpots(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: datesBox.values
                            .map(
                              (e) => InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = e.date;
                                    _spotsList = _generateSpots(_selectedDate);
                                  });
                                },
                                child: Text(
                                    '${e.date.day} ${DateFormat('E').format(e.date).toString()}'),
                              ),
                            )
                            .toList()),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _spotsList?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Text(_spotsList![index].spot.name),
                            // Text(schedule['timeClose']),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
