import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/screens/sections/select_spot/spot_information_screen.dart';
import 'package:touristop/theme/app_colors.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final datesBox = Hive.box<DatesList>('dates');
  final spotsBox = Hive.box<SpotsList>('spots');
  DateTime? _selectedDate;
  List<SpotsList>? _spotsList;
  final List<DateTime> _times = [];

  List<SpotsList> _generateSpots(DateTime? date) {
    final spots = spotsBox.values.where((spotBox) {
      return spotBox.date == _selectedDate ? true : false;
    }).toList();

    _times.clear();

    spots.sort((a, b) {
      final day = DateFormat('E').format(_selectedDate!).toString();
      final scheduleA =
              a.spot.dates.firstWhere((element) => element['date'] == day),
          scheduleB =
              b.spot.dates.firstWhere((element) => element['date'] == day);

      String timeA = (scheduleA['timeClose'] as String)
              .replaceAll(RegExp('[^0-9:]'), ''),
          timeB = (scheduleB['timeClose'] as String)
              .replaceAll(RegExp('[^0-9:]'), '');

      TimeOfDay todA = _toTimeOfDay(timeA), todB = _toTimeOfDay(timeB);

      return toDouble(todA) > toDouble(todB) ? 1 : 0;
    });

    final now = DateTime.now();
    _times.add(
        DateTime(now.year, now.month, now.day).add(const Duration(hours: 8)));

    return spots;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = datesBox.values.first.dateTime;
    _spotsList = _generateSpots(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);
    final selectedSpots = ref.watch(selectedSpotsProvider);

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(3),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 3, 3, 3), width: 4),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 110,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: dates.datesList.map(
                          (e) {
                            return Container(
                              color: _selectedDate == e.dateTime
                                  ? AppColors.slime
                                  : Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = e.dateTime;
                                    _spotsList = _generateSpots(_selectedDate);
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
                                      child: Text(
                                        '${e.dateTime.day}',
                                        style: GoogleFonts.inter(
                                          fontSize: 44,
                                          fontWeight: FontWeight.bold,
                                          color: _selectedDate == e.dateTime
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Text(
                                        DateFormat('E')
                                            .format(e.dateTime)
                                            .toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: _selectedDate == e.dateTime
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_spotsList!.isEmpty)
                    const Center(
                      child: Text('Please select tourist spots in this date.'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _spotsList?.length,
                        itemBuilder: (context, index) {
                          _addTime(
                              _spotsList![index].spot.numberOfHours.toInt());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _dateToTime(_times[index]),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  selectedSpots
                                      .setFirstSpot(_spotsList![index].spot);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpotInformation(
                                        spot: _spotsList![index].spot,
                                        isSelectable: false,
                                        isSchedule: true,
                                      ),
                                    ),
                                  );
                                },
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.45,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          _spotsList![index].isDone = true;

                                          setState(() {});
                                        },
                                        backgroundColor: const Color.fromRGBO(
                                            93, 230, 197, 1),
                                        foregroundColor: Colors.white,
                                        icon: Icons.check_circle_outline,
                                        label: 'Done',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {},
                                        backgroundColor: const Color.fromARGB(
                                            255, 249, 97, 97),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                alignment: Alignment.centerLeft,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    _spotsList![index]
                                                        .spot
                                                        .name,
                                                    overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  initialRating:
                                                      _spotsList![index]
                                                              .spot
                                                              .averageRating!
                                                              .isNaN
                                                          ? 0
                                                          : _spotsList![index]
                                                              .spot
                                                              .averageRating!,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 25,
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
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
                                              _spotsList![index]
                                                  .spot
                                                  .description,
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
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TimeOfDay _toTimeOfDay(String time) {
    return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]));
  }

  void _addTime(int hour) {
    _times.add(_times.last.add(Duration(hours: hour)));
  }

  String _dateToTime(DateTime date) {
    return DateFormat.jm().format(date).toString();
  }

  double toDouble(TimeOfDay time) => time.hour + time.minute / 60.0;
}
