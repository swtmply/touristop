import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_information/destination_information.dart';
import 'package:touristop/screens/destination_selection/add_destination_screen.dart';
import 'package:touristop/screens/schedule/widgets/schedule_list_item.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/boxes.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final scheduleBox = Hive.box<Schedule>(Boxes.schedule);
  final selectedDestinationsBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);
  late DateTime _selectedDate;
  // List<SelectedDestination> _destinations = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDate = scheduleBox.values.first.date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = DateUtils.dateOnly(_selectedDate).toString();
    final schedule = scheduleBox.get(key);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // await selectedDestinationsBox.clear();

                            setState(
                              () => _isEditing = !_isEditing,
                            );
                          },
                          style: TextButton.styleFrom(
                            primary: AppColors.coldBlue,
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          child: _isEditing
                              ? const Icon(Icons.save)
                              : const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.base,
                    ),
                  ],
                ),
              ),
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
                    children: scheduleBox.values.map(
                      (e) {
                        return Container(
                          color: _selectedDate == e.date
                              ? AppColors.slime
                              : Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDate = e.date;
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
                                    '${e.date.day}',
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      color: _selectedDate == e.date
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Text(
                                    DateFormat('E').format(e.date).toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedDate == e.date
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
              const SizedBox(height: AppSpacing.base),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.small,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start Time: ${_dateToTime(schedule!.startHour ?? DateTime(2022, 1, 1, 8))}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDestinationScreen(
                              selectedDate: _selectedDate,
                            ),
                          ),
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.plus),
                      label: const Text('Add Tourist Spot'),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Box<SelectedDestination>>(
                  valueListenable: selectedDestinationsBox.listenable(),
                  builder: (context, box, _) {
                    final destinations = box.values
                        .where(
                          (element) => element.dateSelected == _selectedDate,
                        )
                        .toList();

                    if (destinations.isEmpty) {
                      return const Center(
                        child: Text(
                            'No selected tourist stops in the current date.'),
                      );
                    }

                    return _isEditing
                        ? ReorderableListView.builder(
                            onReorder: (o, i) => _onReorder(o, i),
                            itemCount: destinations.length,
                            itemBuilder: (context, index) => ScheduleListItem(
                              key: Key('$index'),
                              selectedDestination: destinations[index],
                              isEditing: _isEditing,
                            ),
                          )
                        : ListView.builder(
                            itemCount: destinations.length,
                            itemBuilder: (context, index) => ScheduleListItem(
                              selectedDestination: destinations[index],
                              isEditing: _isEditing,
                            ),
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

  void _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    final oldItem = selectedDestinationsBox.getAt(oldIndex);
    final newItem = selectedDestinationsBox.getAt(newIndex);

    await selectedDestinationsBox.delete(oldIndex);
    await selectedDestinationsBox.delete(newIndex);

    setState(() {
      // here you just swap this box item, oldIndex <> newIndex
      selectedDestinationsBox.put(oldIndex, newItem!);
      selectedDestinationsBox.put(newIndex, oldItem!);
    });
  }

  String _dateToTime(DateTime date) {
    return DateFormat.jm().format(date).toString();
  }
}
