import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/theme/app_colors.dart';

class ClustersScheduleScreen extends ConsumerStatefulWidget {
  const ClustersScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClustersScheduleScreenState();
}

class _ClustersScheduleScreenState
    extends ConsumerState<ClustersScheduleScreen> {
  final datesBox = Hive.box<DatesList>('dates');
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = datesBox.values.first.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 3, 3, 3), width: 4),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: datesBox.values.map((e) {
                    return Container(
                      color: _date == e.dateTime
                          ? AppColors.slime
                          : Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _date = e.dateTime;
                            // _spotsList = _generateSpots(_date);
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 20,
                                right: 20,
                              ),
                              child: Text('${e.dateTime.day}',
                                  style: GoogleFonts.inter(
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: _date == e.dateTime
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                  DateFormat('E').format(e.dateTime).toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: _date == e.dateTime
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
