// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_selection/widgets/datetime_picker.dart';
import 'package:touristop/screens/destination_selection/widgets/destination_list_item.dart';
import 'package:touristop/screens/destination_selection/widgets/type_filters.dart';
import 'package:touristop/screens/main_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/boxes.dart';
import 'package:collection/collection.dart';

class DestinationSelectionScreen extends ConsumerStatefulWidget {
  const DestinationSelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends ConsumerState<DestinationSelectionScreen> {
  final scheduleBox = Hive.box<Schedule>(Boxes.schedule);
  final selectedDestinationBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);

  final filterItems = ['Church', 'Museum', 'Park', 'Zoo'];
  final List<String> _selectedFilter = [];
  final List<TimeOfDay?> _selectedTimes = [];
  List<Destination> _destinations = [];
  late DateTime _selectedDate;
  List<Destination> _temp = [];

  final ScrollController _hideButtonController = ScrollController();
  bool _isFABVisible = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = scheduleBox.values.first.date;

    Destination.destinations().then((value) {
      setState(() {
        value.sort((a, b) => a.rating! < b.rating! ? 1 : 0);
        _destinations = value;
        _temp = _destinations;
      });
    });

    _hideButtonController.addListener(_hideFABOnScroll);
  }

  @override
  Widget build(BuildContext context) {
    final key = DateUtils.dateOnly(_selectedDate).toString();
    final schedule = scheduleBox.get(key);

    if (schedule!.startHour != null) {
      _selectedTimes.addAll([
        TimeOfDay.fromDateTime(schedule.startHour!),
        TimeOfDay.fromDateTime(schedule.endHour!),
      ]);
    } else {
      _selectedTimes.clear();
    }

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity: _isFABVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: FloatingActionButton.extended(
          splashColor: AppColors.slime,
          backgroundColor: AppColors.coldBlue,
          label: const Text('Continue'),
          icon: const Icon(Icons.arrow_forward_outlined),
          onPressed: () {
            bool warning = false;
            for (var schedule in scheduleBox.values) {
              final data =
                  selectedDestinationBox.values.firstWhereOrNull((element) {
                final currentDate = DateUtils.dateOnly(schedule.date);
                final selectedDestinationDate =
                    DateUtils.dateOnly(element.dateSelected);

                return currentDate == selectedDestinationDate;
              });

              if (data == null) {
                warning = true;
                break;
              }
            }

            if (warning) {
              showDialog(
                context: context,
                builder: (context) => _showWarning(),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxl),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Destinations',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.small,
                    ),
                    Filters(
                      filterItems: filterItems,
                      selectedItems: _selectedFilter,
                      onChange: (value) {
                        setState(() {
                          if (_selectedFilter.contains(value)) {
                            _selectedFilter.remove(value);
                          } else {
                            _selectedFilter.add(value);
                          }
                          _updateFilter();
                        });
                      },
                    ),
                    const SizedBox(
                      height: AppSpacing.base,
                    ),
                    DateTimePicker(
                      selectedDate: _selectedDate,
                      selectedTimes: _selectedTimes,
                      onDateChange: (date) {
                        setState(() {
                          _selectedDate = date;
                          _updateFilter();
                        });
                      },
                      onTimesChange: (times) {
                        setState(() {
                          _selectedTimes.clear();
                          _selectedTimes.addAll([
                            times.startTime,
                            times.endTime,
                          ]);

                          schedule.startHour = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTimes[0]!.hour,
                            _selectedTimes[0]!.minute,
                          );
                          schedule.endHour = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            _selectedTimes[1]!.hour,
                            _selectedTimes[1]!.minute,
                          );
                          schedule.save();

                          _updateFilter();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSpacing.large,
              ),
              Expanded(
                child: _destinations.isEmpty
                    ? const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            colors: AppColors.cbToSlime,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _hideButtonController,
                        itemCount: _destinations.length,
                        itemBuilder: (context, index) {
                          return DestinationListItem(
                            destination: _destinations[index],
                            selectedDate: _selectedDate,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showWarning() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: SizedBox(
          height: 135,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Please select a tourist spot/s in all of the dates. Some dates will have no schedule, are you sure you want to continue?'),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.slime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: AppColors.coldBlue,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _updateFilter() {
    setState(() {
      // type filter

      if (_selectedFilter.isNotEmpty) {
        _destinations = _temp
            .where((element) => _selectedFilter.contains(element.type))
            .toList();
      } else {
        _destinations = _temp;
      }

      // date filter

      final date = DateFormat.E().format(_selectedDate);
      _destinations = _destinations.where((element) {
        final data = element.schedule.where((day) => day.date == date);
        return data.isEmpty ? false : true;
      }).toList();

      // sort by rating

      _destinations.sort((a, b) => a.rating! < b.rating! ? 1 : 0);
    });
  }

  _hideFABOnScroll() {
    if (_hideButtonController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isFABVisible == true) {
        setState(() {
          _isFABVisible = false;
        });
      }
    } else {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isFABVisible == false) {
          setState(() {
            _isFABVisible = true;
          });
        }
      }
    }
  }
}
