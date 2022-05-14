import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:touristop/main.dart';

class SelectedDates extends ConsumerWidget {
  const SelectedDates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(datesProvider);

    if (data.dates.isEmpty) return const Text('Please select a date/s');

    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: data.dates
          .map((date) => InkWell(
                onTap: () {},
                child: DateContainer(
                  date: date,
                ),
              ))
          .toList(),
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
