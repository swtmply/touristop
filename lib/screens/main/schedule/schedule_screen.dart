import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';
import 'package:touristop/screens/main/select_spots/widgets/spot_list_item.dart';

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
    return spotsBox.values.where((spotBox) {
      return spotBox.selectedDate == _selectedDate ? true : false;
    }).toList();
  }

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
                          return Text(_spotsList![index].spot.name);
                        }),
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
