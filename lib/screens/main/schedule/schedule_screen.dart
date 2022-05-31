import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:touristop/theme/app_colors.dart';

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
                  Container(
                    padding: EdgeInsets.all(3),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 3, 3, 3), width: 4)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: datesBox.values
                              .map(
                                (e) => Container(
                                  color: _selectedDate == e.date
                                      ? AppColors.slime
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = e.date;
                                        _spotsList =
                                            _generateSpots(_selectedDate);
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 20, right: 20),
                                          child: Text('${e.date.day}',
                                              style: GoogleFonts.inter(
                                                fontSize: 44,
                                                fontWeight: FontWeight.bold,
                                                color: _selectedDate == e.date
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child:  Text(
                                              '${DateFormat('E').format(e.date).toString()}',
                                              style: GoogleFonts.inter(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: _selectedDate == e.date
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _spotsList?.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Slidable(
                              endActionPane: ActionPane(
                                extentRatio: 0.45,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {},
                                    backgroundColor:
                                        Color.fromRGBO(93, 230, 197, 1),
                                    foregroundColor: Colors.white,
                                    icon: Icons.check_circle_outline,
                                    label: 'Done',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) {},
                                    backgroundColor:
                                        Color.fromARGB(255, 249, 97, 97),
                                    foregroundColor: Colors.white,
                                    icon: Icons.cancel_outlined,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        _spotsList![index].spot.image),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.6),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                _spotsList![index].spot.name,
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10),
                                            child: RatingBar.builder(
                                              ignoreGestures: true,
                                              unratedColor:
                                                  const Color.fromARGB(
                                                      100, 255, 241, 114),
                                              initialRating: _spotsList![index]
                                                      .spot
                                                      .averageRating ??
                                                  0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 25,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Color.fromRGBO(
                                                    255, 239, 100, 1),
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 30),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _spotsList![index].spot.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
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
