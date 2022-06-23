import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/boxes.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final List<TimeOfDay?> selectedTimes;
  final Function(DateTime date) onDateChange;
  final Function(TimeRangeValue times) onTimesChange;
  const DateTimePicker({
    Key? key,
    required this.selectedDate,
    required this.selectedTimes,
    required this.onDateChange,
    required this.onTimesChange,
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final scheduleBox = Hive.box<Schedule>(Boxes.schedule);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Date:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(
                height: AppSpacing.small,
              ),
              DropdownButton2(
                items: scheduleBox.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.date,
                        child: Text(
                          '${DateFormat.yMd().format(e.date)} - ${DateFormat.E().format(e.date)}',
                        ),
                      ),
                    )
                    .toList(),
                isExpanded: true,
                customButton: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.selectedDate != null
                            ? DateFormat.yMd().format(widget.selectedDate!)
                            : 'Selected Date',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const FaIcon(
                        FontAwesomeIcons.sort,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                onChanged: (value) {
                  widget.onDateChange(value as DateTime);
                },
              ),
            ],
          ),
          const SizedBox(
            width: AppSpacing.small,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Time:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(
                height: AppSpacing.small,
              ),
              InkWell(
                onTap: () => TimeRangePicker.show(
                  context: context,
                  onSubmitted: (TimeRangeValue value) {
                    widget.onTimesChange(value);
                  },
                  okLabel: 'CONFIRM',
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.selectedTimes.isEmpty
                        ? 'No selected time'
                        : '${widget.selectedTimes.first!.format(context)}-${widget.selectedTimes.last!.format(context)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
