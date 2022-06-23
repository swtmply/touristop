// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/screens/destination_selection/destination_selection_screen.dart';
import 'package:touristop/screens/main_screen.dart';
import 'package:touristop/screens/schedule/schedule_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/boxes.dart';

class SelectionDialog extends ConsumerStatefulWidget {
  final DateTime start;
  final DateTime end;
  const SelectionDialog({Key? key, required this.start, required this.end})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectionDialogState();
}

class _SelectionDialogState extends ConsumerState<SelectionDialog> {
  bool _isLoading = false;
  List<String> plans = ['Plan your own trip', 'Let us plan it for you'];
  String plan = "";
  final scheduleBox = Hive.box<Schedule>(Boxes.schedule);

  _savePlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('plan', plan);
  }

  _initDates() async {
    final startDate = DateUtils.dateOnly(widget.start);
    final endDate = DateUtils.dateOnly(widget.end);
    final dateDiff = endDate.difference(startDate).inDays;

    await scheduleBox.clear();

    for (int i = 0; i < dateDiff + 1; i++) {
      final date = DateUtils.addDaysToDate(startDate, i);
      final schedule = Schedule(date: date);
      final key = DateUtils.dateOnly(date).toString();

      final data = scheduleBox.get(key);
      if (data == null) {
        scheduleBox.put(key, schedule);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initDates();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: AppColors.cbToSlime,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Generating your schedule. Please wait...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose a plan for your trip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SelectionCard(
                        title: plans.first,
                        body:
                            'Choose a date/s and pick the tourist spots you want to go to.',
                        selected: plan,
                        onClick: (value) {
                          setState(() {
                            plan = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SelectionCard(
                        title: plans.last,
                        body:
                            'Sit back and relax. The application will generate everything for you',
                        selected: plan,
                        onClick: (value) {
                          setState(() {
                            plan = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 180,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(93, 107, 230, 1),
                                Color.fromRGBO(93, 230, 197, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              if (plan == plans.last) {
                                setState(() {
                                  _isLoading = true;
                                });

                                final List<String> bundles = [];

                                for (var schedule in scheduleBox.values) {
                                  await Destination.setBundlebyDate(
                                    schedule.date,
                                    bundles,
                                  );
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DestinationSelectionScreen(),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    Key? key,
    required this.title,
    required this.body,
    required this.selected,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final String body;
  final String selected;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(title),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected == title ? AppColors.slime : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColors.darkGray,
              blurRadius: 5,
              offset: Offset(1, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.coldBlue,
                    AppColors.slime,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: selected == title ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    body,
                    style: TextStyle(
                      color:
                          selected == title ? Colors.white : AppColors.darkGray,
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
}
