import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';

class SelectedDates extends ConsumerWidget {
  const SelectedDates({Key? key, required this.controller}) : super(key: key);

  final DateRangePickerController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(datesProvider);

    if (dates.datesList.isEmpty) {
      return const Text('Please select a date/s');
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200,
      ),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10,
          spacing: 10,
          children: dates.datesList
              .map((date) => InkWell(
                    onTap: () {
                      dates.removeDate(date);
                      controller.selectedDates?.remove(date.dateTime);
                      controller
                          .notifyPropertyChangedListeners('selectedDates');
                    },
                    child: DateContainer(
                      date: date.dateTime,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class DateContainer extends StatelessWidget {
  const DateContainer({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Text(
              DateFormat('MMM').format(date).toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              '${date.day}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(DateFormat('EE').format(date).toString()),
          ],
        ),
      ),
    );
  }
}
